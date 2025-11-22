pipeline {
    agent any

    options {
        timestamps()
        buildDiscarder(logRotator(daysToKeepStr: '30'))
    }

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'pockaw-app', description: 'Docker image name')
        string(name: 'DOCKER_REGISTRY', defaultValue: '', description: 'Optional Docker registry (e.g. registry.hub.docker.com/username)')
        booleanParam(name: 'PUSH_IMAGE', defaultValue: false, description: 'Push built image to registry')
    }

    environment {
        // Image tag includes build number; registry prefix is optional
        DOCKER_IMAGE = "${params.DOCKER_REGISTRY ? params.DOCKER_REGISTRY + '/' : ''}${params.IMAGE_NAME}:${env.BRANCH_NAME ?: 'branch'}-${env.BUILD_NUMBER}"
        // SONAR_TOKEN: provide a Jenkins Secret Text credential with id 'SONAR_TOKEN' if you want Sonar scans
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker --version || true'
                sh "docker build -t ${env.DOCKER_IMAGE} ."
            }
        }

        stage('Push Image') {
            when {
                expression { return params.PUSH_IMAGE }
            }
            steps {
                // This expects two Jenkins credentials (username/password) with ids 'DOCKERHUB_USER' and 'DOCKERHUB_PASS'
                withCredentials([string(credentialsId: 'DOCKERHUB_USER', variable: 'DH_USER'), string(credentialsId: 'DOCKERHUB_PASS', variable: 'DH_PASS')]) {
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin ${params.DOCKER_REGISTRY ?: ""}'
                    sh "docker push ${env.DOCKER_IMAGE}"
                }
            }
        }

        stage('SonarQube') {
            when {
                expression { return env.SONAR_HOST_URL }
            }
            steps {
                // Requires `sonar-scanner` installed on agent, or use SonarQube plugin (adapt as needed)
                sh "sonar-scanner -Dsonar.projectKey=${env.JOB_NAME} -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${SONAR_TOKEN}"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'index.html', fingerprint: true
            cleanWs()
        }
        success {
            echo "Build ${env.BUILD_NUMBER} succeeded. Image: ${env.DOCKER_IMAGE}"
        }
        failure {
            echo "Build failed. See console output for details."
        }
    }
}
