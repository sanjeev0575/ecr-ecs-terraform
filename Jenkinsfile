pipeline {
    agent any
    environment {
        AWS_REGION     = "us-east-1"
        ECR_REPO_NAME  = "my-flask-app"
        IMAGE_TAG      = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/sanjeev0575/ecr-ecs-terraform.git'
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Get ECR Repo URL') {
            steps {
                script {
                    ECR_REPO_URL = sh(
                        script: "terraform -chdir=terraform output -raw ecr_repository_url",
                        returnStdout: true
                    ).trim()
                    env.ECR_REPO_URL = ECR_REPO_URL
                }
            }
        }
        stage('ECR Login') {
            steps {
                withCredentials([aws(
                    credentialsId: 'aws-cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | \
                        docker login --username AWS --password-stdin $ECR_REPO_URL
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t $ECR_REPO_NAME:$IMAGE_TAG ."
            }
        }
        stage('Tag Docker Image') {
            steps {
                sh "docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_REPO_URL:$IMAGE_TAG"
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                sh "docker push $ECR_REPO_URL:$IMAGE_TAG"
            }
        }
    }
}
