pipeline {
    agent any
    
    environment {
        // Define environment variables for your Terraform configuration
        TF_WORKSPACE = 'production'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                checkout scm
            }
        }
        
        stage('Initialize') {
            steps {
                // Initialize Terraform and select a workspace
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh 'terraform init'
                sh "terraform workspace select ${TF_WORKSPACE}"
            }
            }
        }
        
        stage('Plan') {
            steps {
                // Create a Terraform plan
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh 'terraform plan -out=tfplan'
            }
            }
        }
        
        stage('Apply') {
            when {
                // You can choose when to apply the Terraform changes, e.g., manual approval
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                // Apply the Terraform changes
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh 'terraform apply -auto-approve tfplan'
            }
            }
        }
        
        stage('Destroy') {
            when {
                // You can add conditions for when to destroy the infrastructure
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                // Destroy the Terraform-managed infrastructure (be very careful with this)
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
clou