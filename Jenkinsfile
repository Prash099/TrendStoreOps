pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-pat')
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        IMAGE_NAME = 'prash099/prash-trend-store-app'
        IMAGE_TAG = 'latest'
    }

    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Prash099/TrendStoreOps.git'
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying dev branch..."
                    sh 'chmod +x deploy.sh'
                    sh './deploy.sh'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                // Apply both deployment and service manifests
                script {
                    sh 'kubectl get nodes'
                    echo "kubectl get nodes $"
                }
                sh "kubectl apply -f k8s/deployment.yaml"
                sh "kubectl apply -f k8s/service.yaml"
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods'
                sh 'kubectl get svc'
            }
        }
    }
}
