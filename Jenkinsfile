def workspaceConfigs = [
    'DEVEOPMENT': ['dev', 'qa'],
    'PRODUCTION': ['prod', 'production'],
]

pipeline {
    agent {
        label 'master'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                checkout scm
            }
        }

        // stage('Initialization') {
        //     steps {
        //         // Initialize Terraform and select a workspace
        //         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
        //         sh "terraform init"
        //     }
        //     }
        // }
        
         stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'terraform_CICD']]){
                script {
                    workspaceConfigs.each { env, items ->
                        parallel "$env": {
                            node('master') {
                                
                                    items.each { item ->
                                        stage("Plan ${env} - ${item}") {
                                            sh "terraform init"
                                            sh "terraform workspace select ${item}"
                                            sh 'terraform plan -out=tfplan -var-file vars/"$(terraform workspace show).tfvars"'
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
         }
        


        
    }
}
