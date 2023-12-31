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

def takeApproval(String stageName) {
    stage("Approval for $stageName") {
        
            script {
                  def userInput = input(
                        id: 'userInput',
                        message: 'Select an action:',
                        parameters: [
                            choice(name: 'ACTION', choices: 'Proceed\nAbort', description: 'Choose an action')
                        ]
                    )

                    if (userInput == 'Proceed') {
                        echo 'Proceeding with the next steps.'
                    } else if (userInput == 'Abort') {
                        currentBuild.result = 'ABORTED'
                        error('User chose to abort all steps.')
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
                    stage('Checkout') {
                                        checkout scm
    
                                }
                        stage('Terraform Init') {
                            terraforminit()
                        }

                    for (workspace in workspaceList.PRODUCTION){
                        

                        stage("Terraform plan for $workspace"){
                            
                                terraformplan(workspace)
                        }
                        
                        takeApproval(workspace)

                        stage("Terraform apply for $workspace"){
                            
                                terraformapply()
                        }
                    }
                }
            }
        }
        }

        stage('Terraform Dev Deployment'){
            agent { label 'dev'}
            when {
                branch 'dev' // Only build the 'main' branch
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    stage('Checkout') {
                                        checkout scm
    
                                }
                        stage('Terraform Init') {
                            terraforminit()
                        }
                    for (workspace in workspaceList.DEVELOPMENT){
                        
                        stage("Terraform plan for $workspace"){
                            
                                terraformplan(workspace)
                        }
                        
                        takeApproval(workspace)

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