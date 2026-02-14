pipeline {
    agent any

    environment {
        IMAGE_NAME = "anildcoder/jenkins-test"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/AnilDCoder/jenkins-test.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use kubectl on the host, not inside Jenkins container
                sh "kubectl set image deployment/jenkins-test jenkins-test=${IMAGE_NAME}:${IMAGE_TAG} || kubectl apply -f k8s/deployment.yaml"
            }
        }

        stage('Verify Deployment') {
            steps {
                sh "kubectl get pods -l app=jenkins-test"
                sh "kubectl get svc jenkins-test"
            }
        }
    }
}