pipeline {
    agent any

    environment {
        REGISTRY_CREDS = 'docker-hub-credentials'
        IMAGE_NAME     = 'aceest-fitness-app'
        DOCKER_USER    = 'your-dockerhub-username' // Make sure this matches your real Docker Hub profile name
    }

    stages {
        stage('Execute PyTest Verification Suite') {
            steps {
                echo 'Launching Unit Test suites inside an isolated runtime container...'
                // Spins up a quick runtime container using shell script blocks
                sh 'docker run --rm -v "$(pwd)":/app -w /app python:3.11-slim sh -c "pip install --no-cache-dir -r requirements.txt && python -m pytest tests/"'
            }
        }

        stage('Secure Image Container Build & Push') {
            steps {
                echo 'Assembling production container image and shipping to Docker Hub...'
                script {
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
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
