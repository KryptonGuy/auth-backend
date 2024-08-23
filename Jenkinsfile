pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the Docker image...'
                docker build .
            }
        }
        stage('Test') {
            steps {
                echo 'Testing.,,.'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
