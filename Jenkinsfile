pipeline {
    agent { label 'jenkins-docker'}

    stages {
        stage('Build') {
            steps {
                echo 'Building Something'
                sh 'docker build .'
            }
        }
    }
}

