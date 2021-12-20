pipeline {
    agent any
    environment {
        access_key = credentials('access-key')
        secret_key = credentials('secret-key')
    }
    
    stages {
        stage('Git Clone') {
            steps {
                git 'https://github.com/omerba-nanosek/lambda_app.git'
            }
        }
        stage('Zip') {
            steps {
                sh 'zip -r app.zip app.py'
            }
        }
        stage('AWS Configure') {
            steps {
                sh 'aws configure set aws_access_key_id $access_key'
                sh 'aws configure set aws_secret_access_key $secret_key'
                sh 'aws configure set default.region us-east-1'
            }
        }
        stage ('Copy to S3') {
            steps {
                sh 'aws s3 cp app.zip s3://omerba123/app.zip'
            }
        }
        stage ('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage ('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage ('Terraform Apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}