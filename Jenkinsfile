pipeline {
    agent any

    environment {
        IMAGE_NAME      = "anildcoder/jenkins-test"
        CONTAINER_NAME  = "jenkins-test-container"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AnilDCoder/jenkins-test.git'
            }
        }

        stage('Check Docker') {
            steps {
                sh 'which docker'
                sh 'docker --version'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                sh 'docker rm -f $CONTAINER_NAME || true'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 8081:8080 --name $CONTAINER_NAME $IMAGE_NAME'
            }
        }
    }
}