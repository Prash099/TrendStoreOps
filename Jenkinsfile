pipeline {
    agent any
    environment {
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "trend-cluster"
        DOCKERHUB_USER = "prash099"
        IMAGE_NAME = "prash-trend-store-app"
    }
    stages {
        stage('Create EKS Cluster') {
            steps {
                script {
                    sh """
                    eksctl create cluster \
                      --name $CLUSTER_NAME \
                      --region $AWS_REGION \
                      --nodegroup-name standard-workers \
                      --node-type t3.medium \
                      --nodes 2 \
                      --nodes-min 1 \
                      --nodes-max 3 \
                      --managed
                    """
                }
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                    """
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                script {
                    sh """
                    aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    """
                }
            }
        }
    }
}

