def workspaceList = [
    'DEVELOPMENT': ['dev', 'qa'],
    'PRODUCTION': ['prod', 'production'],
]
def buildTerraform(workspace) {
    stage('Terraform Init') {
        steps {
            script {
                // Initialize Terraform for the specified environment
                sh "terraform init"
            }
        }
    }

    stage('Terraform Plan') {
        steps {
            script {
                // Create an execution plan for the infrastructure changes
                sh "terraform workspace list"
                sh "terraform workspace select ${workspace}"
                sh 'terraform plan -var="vars/${workspace}.tfvars" -out=tfplan'
            }
        }
    }

}

pipeline {
    agent {
        label 'master'
    }

    stages {
        // Define your environment branches here
        stage('Environment Branches') {
            steps {
                script {
                    def workspaces = workspaceList.DEVELOPMENT
                    
                    for (workspace in workspaces) {
                        // Create a node for each environment
                        stage(workspace){
                        node(workspace) {
                            steps{
                            checkout scm
                            buildTerraform(workspace)
                            }
                        }
                    }
                    }
                }
            }
        }
    }


}
