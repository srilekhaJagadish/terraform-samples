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
                sudo terraform plan -out webServer.tfplan
                ls
                sudo terraform apply "webServer.tfplan
                '''
            }
        }
    }
}
