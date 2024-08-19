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
                pwd
                ls
                whoami
                echo 'terraform init ....'
                terraform init 
                echo 'terraform plan ....'
                terraform plan -lock=false -out webServer.tfplan
                ls
                terraform apply "webServer.tfplan
                '''
            }
        }
    }
}
