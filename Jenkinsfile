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
                terraform plan -out=webServerTfplan.tfplan -lock=false
                ls
                terraform apply "webServerTfplan.tfplan"
                '''
            }
        }
    }
}
