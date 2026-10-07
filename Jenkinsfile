pipeline {
    agent any

    environment {
        REGISTRY_CREDS = 'docker-hub-credentials'
        IMAGE_NAME     = 'aceest-fitness-app'
        DOCKER_USER    = 'your-dockerhub-username' // Make sure to replace this with your actual Docker Hub username
    }

    stages {
        stage('Execute PyTest Verification Suite') {
            steps {
                echo 'Launching Unit Test suites inside an isolated python container...'
                // This starts a temporary Python container via shell, mounts the workspace, runs tests, and exits cleanly
                sh 'docker run --rm -v "$(pwd)":/app -w /app python:3.11-slim sh -c "pip install --no-cache-dir -r requirements.txt && python -m pytest tests/"'
            }
        }

        stage('Secure Image Container Build & Push') {
            steps {
                echo 'Assembling production container image and shipping to Docker Hub...'
                script {
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        // Build and tag the app using the mounted Docker engine
                        sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                        sh "docker tag ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USER}/${IMAGE_NAME}:latest"
                        
                        // Log into Docker Hub and push the final artifacts
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
