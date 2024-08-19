pipeline {
    agent any

    stages {
        stage('Deploy') {
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {
                sh '''
                cd aws-resources
                pwd
                ls
                echo 'terraform init ....'
                terraform init 
                echo 'terraform plan ....'
                terraform plan
                ls
                '''
            }
        }
    }
}
