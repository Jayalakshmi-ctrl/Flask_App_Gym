pipeline {
    agent any

    environment {
        REGISTRY_CREDS = 'docker-hub-credentials'
        IMAGE_NAME     = 'aceest-fitness-app'
        DOCKER_USER    = 'your-dockerhub-username' // Make sure to change this to your real Docker Hub username
    }

    stages {
        stage('Execute PyTest Verification Suite') {
            agent {
                docker { 
                    image 'python:3.11-slim'
                    args '-u root'
                }
            }
            steps {
                echo 'Launching Unit Test suites inside a clean Python container...'
                sh 'pip install --no-cache-dir -r requirements.txt'
                sh 'python -m pytest tests/'
            }
        }

        stage('Secure Image Container Build & Push') {
            steps {
                echo 'Assembling production container image and shipping to Docker Hub...'
                script {
                    // This uses your Jenkins credentials to securely log into Docker Hub
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        // Build and push using the host's Docker engine
                        sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                        sh "docker tag ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USER}/${IMAGE_NAME}:latest"
                        
                        sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                        sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Build #${BUILD_NUMBER} distributed."
        }
        failure {
            echo 'Pipeline structural processing failure flagged.'
        }
    }
}
