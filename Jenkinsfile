

pipeline {
    agent any
    
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                checkout scm
            }
        }


        stage('Fetch Terraform Workspaces') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    // Run 'terraform workspace list' and capture the output
                    def workspaces = sh(script: 'terraform workspace list', returnStdout: true).trim()

                    // Split the output into an array
                    def workspaceList = workspaces.split('\n')

                    // Create a list of workspace options
                    def workspaceOptions = workspaceList.collect { workspace ->
                        return [name: workspace, value: workspace]
                    }
                    // Add the custom parameter to the build
                    sh 'terraform init'
                    currentBuild.description = 'Select a Terraform workspace'
                    properties([parameters([choice(name: 'terraform_workspace', choices: workspaceOptions.join('\n'), description: 'Choose a Terraform workspace')])])
                }
            }
            }
        }
        
        stage('Select Workspace') {
            steps {
                // Initialize Terraform and select a workspace
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh "terraform workspace select ${params.terraform_workspace}"
            }
            }
        }
        
        stage('Plan') {
            steps {
                // Create a Terraform plan
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh 'terraform plan -out=tfplan -var-file vars/"$(terraform workspace show).tfvars"'
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
