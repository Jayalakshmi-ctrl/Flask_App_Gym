pipeline {
    agent any

    environment {
        REGISTRY_CREDS = 'docker-hub-credentials'
        IMAGE_NAME     = 'aceest-fitness-app'
        DOCKER_USER    = 'your-dockerhub-username'
    }

    stages {
        stage('Initialize Environment') {
            steps {
                echo 'Validating workspace assets...'
                sh 'python3 --version'
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Execute PyTest Verification Suite') {
            steps {
                echo 'Launching Unit Test suites via PyTest...'
                sh 'pytest tests/ --junitxml=test-reports/results.xml'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }

        stage('Secure Image Container Build') {
            steps {
                echo 'Assembling isolated container environment tier...'
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USER}/${IMAGE_NAME}:latest"
            }
        }

        stage('Artifact Distribution Push') {
            steps {
                echo 'Deploying artifact images out to Docker Registry Hub...'
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline complete successfully! Build #${BUILD_NUMBER} distributed."
        }
        failure {
            echo 'Pipeline structural processing failure flagged.'
        }
    }
}
