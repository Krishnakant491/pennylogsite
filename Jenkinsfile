pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "krishnakant491"
        IMAGE_NAME    = "pennylogsite"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Krishnakant491/pennylogsite.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t \$DOCKERHUB_USER/\$IMAGE_NAME:latest ."
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKERHUB_USER --password-stdin"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "docker push \$DOCKERHUB_USER/\$IMAGE_NAME:latest"
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop pennylogsite || true
                docker rm pennylogsite  || true
                docker pull \$DOCKERHUB_USER/\$IMAGE_NAME:latest
                docker run -d --name pennylogsite -p 80:80 \$DOCKERHUB_USER/\$IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Build or deployment failed."
        }
    }
}