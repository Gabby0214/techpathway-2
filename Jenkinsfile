pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '042984980856'

        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        BACKEND_REPO = "${ECR_REGISTRY}/techpathway-backend"
        FRONTEND_REPO = "${ECR_REGISTRY}/techpathway-frontend"

        ECS_CLUSTER = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE = 'techpathway-frontend-service'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Build Backend') {
            steps {
                sh '''
                    docker build \
                    --platform linux/amd64 \
                    -t $BACKEND_REPO:latest \
                    ./backend
                '''
            }
        }

        stage('Build Frontend') {
            steps {
                sh '''
                    docker build \
                    --platform linux/amd64 \
                    -t $FRONTEND_REPO:latest \
                    ./frontend
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    docker push $BACKEND_REPO:latest
                    docker push $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                    --cluster $ECS_CLUSTER \
                    --service $BACKEND_SERVICE \
                    --force-new-deployment \
                    --region $AWS_REGION

                    aws ecs update-service \
                    --cluster $ECS_CLUSTER \
                    --service $FRONTEND_SERVICE \
                    --force-new-deployment \
                    --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }

        failure {
            echo 'Deployment failed. Check the Jenkins console output.'
        }
    }
}