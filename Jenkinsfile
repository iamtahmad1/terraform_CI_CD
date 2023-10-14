

pipeline {
    agent any
    
    environment {
        // Default workspace
        terraform_workspace = null
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                checkout scm
            }
        }

        stage('Initialization') {
            steps {
                // Initialize Terraform and select a workspace
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh "terraform init"
            }
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
                        return workspace
                    }
                    // Add the custom parameter to the build
                    

                    def userInput = input(
                        id: 'workspace-selection',
                        message: 'Select a Terraform workspace:',
                        parameters: [choice(name: 'tf_workspace', choices: workspaceOptions.join('\n'), description: 'Choose a Terraform workspace')]
                    )
                    env.terraform_workspace = userInput
                }
            }
            }
        }
        
        stage('Select Workspace') {
            steps {
                // Initialize Terraform and select a workspace
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh "terraform workspace select '${env.terraform_workspace}'"
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
        stage('Apply Approval') {
            steps {
                script {
                    // Use the "input" step to request approval
                    def userInput = input(
                        id: 'approval',
                        message: 'Do you approve applying these Terraform changes?',
                        parameters: [choice(name: 'APPROVAL', choices: 'Yes\nNo', description: 'Choose Yes to approve or No to reject')]
                    )
                    
                    if (userInput == 'No') {
                        currentBuild.result = 'FAILURE'
                        error('Approval denied. Aborting the pipeline.')
                    }
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
        
        stage('Destroy Approval') {
            steps {
                script {
                    // Use the "input" step to request approval
                    def userInput = input(
                        id: 'approval',
                        message: 'Do you approve applying these Terraform changes?',
                        parameters: [choice(name: 'APPROVAL', choices: 'Yes\nNo', description: 'Choose Yes to approve or No to reject')]
                    )
                    
                    if (userInput == 'No') {
                        currentBuild.result = 'FAILURE'
                        error('Approval denied. Aborting the pipeline.')
                    }
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                sh 'terraform destroy -auto-approve -var-file vars/"$(terraform workspace show).tfvars'
            }
        }
        }
    }
}
