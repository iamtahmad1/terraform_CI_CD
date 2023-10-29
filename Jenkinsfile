def workspaceList = [
    'DEVELOPMENT': ['dev', 'qa'],
    'PRODUCTION': ['prod', 'production'],
]

def terraforminit() {
    // Your common steps or tasks go here
    sh "terraform init"
}


def terraformplan(workspace) {
    // Your common steps or tasks go here
    sh "terraform workspace select '$workspace'"
    sh "terraform plan -out=tfplan -var-file vars/'$workspace'.tfvars"
}

def terraformapply() {
    // Your common steps or tasks go here
    sh "terraform apply -auto-approve tfplan"
}

def approvalStep(String stageName) {
    stage(stageName) {
        
            script {
                def approvalResult = input(id: "${stageName}_approval", message: "Do you approve ${stageName}?", ok: "Approve")
                if (approvalResult == 'no') {
                    error("Approval for ${stageName} was declined. Aborting the pipeline.")
                }
            }
        
    }
}


pipeline {
    agent any

    stages {
        
        // stage('Initialization') {
        //     steps {
        //         // Initialize Terraform and select a workspace
        //         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
        //         terraforminit()
        //     }
        //     }
        // }

        stage('Terraform Prod Deployment'){
            agent { label 'prod'}
            when {
                branch 'main' // Only build the 'main' branch
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    for (workspace in workspaceList.PRODUCTION){
                        stage('Checkout') {
                                        checkout scm
    
                                }
                        stage('Terraform Init') {
                            terraforminit()
                        }

                        stage("Terraform plan for $workspace"){
                            
                                terraformplan(workspace)
                        }
                        
                        approvalStep(workspace)

                        stage("Terraform apply for $workspace"){
                            
                                terraformapply()
                        }
                    }
                }
            }
        }
        }

        stage('Terraform Dev Deployment'){
            when {
                branch 'dev' // Only build the 'main' branch
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    for (workspace in workspaceList.DEVELOPMENT){
                        
                        stage("Terraform plan for $workspace"){
                            
                                terraformplan(workspace)
                        }
                        
                        approvalStep(workspace)

                        stage("Terraform apply for $workspace"){
                            
                                terraformapply()
                        
                    }
                }
                }
            }
        }
        }
    }
}