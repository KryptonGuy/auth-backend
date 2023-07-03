data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_caller_identity" "current" {} 

locals {
  cluster_name = "${var.name_prefix}-${var.environment}"

  admin_user_map_users = [
    for admin_user in var.admin_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]

  developer_user_map_users = [
    for developer_user in var.developer_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${developer_user}"
      username = developer_user
      groups   = ["${var.name_prefix}-developers"]
    }
  ]
}

resource "aws_eip" "nat_gw_elastic_ip" {
  vpc = true

  tags = {
    Name        = "${local.cluster_name}-nat-eip"
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.27"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  create_cloudwatch_log_group = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_security_group_additional_rules = {
    ingress_nodes_8443_tcp = {
      description                = "Node groups to cluster API via port 8443"
      protocol                   = "tcp"
      from_port                  = 8080
      to_port                    = 8080
      type                       = "ingress"
      source_node_security_group = true
    }
  }


  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    system = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = var.asg_sys_instance_types
      labels = {
        Environment = "dev"
      }
      tags = {
        Terraform   = "true"
        Environment = "dev"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks

  map_users = concat(local.admin_user_map_users, local.developer_user_map_users)
  map_roles = [
    {
      rolearn  = "arn:aws:iam::734702322667:role/LoginSystemCodeBuild"
      username = "LoginSystemCodeBuild"
      groups   = ["system:masters"]
    },
  ]
}
