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
    sh 'terraform select $workspace'
    sh 'terraform plan -out=tfplan -var-file vars/"($workspace).tfvars"'
}

def terraformapply() {
    // Your common steps or tasks go here
    sh 'sh terraform apply -auto-approve tfplan'
}

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
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

        stage('Terraform Plan'){
            when {
                branch 'main' // Only build the 'main' branch
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    for (workspace in workspaceList.PRODUCTION){
                        stage("Terraform plan for $workspace"){
                            
                                terraformplan($workspace)
                        }
                    }
                }
            }
        }
        }
    }
}