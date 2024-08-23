pipeline {
    agent any

    stage('Pre-Build') {
            steps {
                echo 'Testing.,,.'
            }
        }

    stages {
        stage('Build') {
            steps {
                echo 'Building the Docker image...'
                docker build .
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
