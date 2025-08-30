pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'docker-hub-pat'        // Jenkins global credential
        KUBECONFIG = '/var/lib/jenkins/.kube/config'    // Path to kubeconfig for EKS
        IMAGE_NAME = 'prash099/prash-trend-store-app' // DockerHub repo
        IMAGE_TAG = 'latest'
    }

    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Prash099/TrendStoreOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                // Update deployment image
                sh "kubectl set image -f k8s/deployment.yml nginx-container=${IMAGE_NAME}:${IMAGE_TAG}"
                
                // Apply both deployment and service manifests
                sh "kubectl apply -f k8s/deployment.yml"
                sh "kubectl apply -f k8s/service.yml"
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
