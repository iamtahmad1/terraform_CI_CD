pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform code from SCM
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform in the project directory
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') 
            steps {
                script {
                    // Apply Terraform changes
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                // Define when to destroy resources
            }
            steps {
                script {
                    // Destroy Terraform resources
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
