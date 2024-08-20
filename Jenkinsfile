pipeline {
    agent any

    stages {
        stage('terraform init') {
            options {
                timeout(time: 5, unit: 'MINUTES')
            }
            steps {
                sh '''
                cd aws-resources
                echo 'terraform init ....'
                terraform init 
                '''
            }
        }
        stage('terraform plan'){
            steps {
                sh '''
                cd aws_resources
                echo 'terraform plan ....'
                terraform plan -out webServer.tfplan
                ls
                '''
                 stash includes: '*/*.tfplan', name: 'planfile' 
            }
        }
        stage('terraform apply'){
            steps {
                unstash 'planfile'
                sh '''
                cd aws_resources
                echo 'terraform apply ....'
                terraform apply "webServer.tfplan"
                '''
            }
        }
    }
}
