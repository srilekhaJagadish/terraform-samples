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
                echo 'terraform init ....'
                terraform init 
                echo 'terraform plan ....'
                sudo terraform plan -out=webServerTfplan.tfplan
                ls
                sudo terraform apply "webServerTfplan.tfplan"
                '''
            }
        }
    }
}
