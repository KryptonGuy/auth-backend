terraform {
  required_version = ">= 1.0"

  required_providers {
    aws        = "~> 4.29"
    kubernetes = "~> 2.10"
    google     = "~> 4.34"
  }
}
