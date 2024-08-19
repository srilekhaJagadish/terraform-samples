pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'echo successful!!!!!!!!!!!!!'
                sh '''
                cd aws-resources
                pwd
                ls
                terraform init 
                terraform plan 
                terraform apply -auto-approve
                '''
            }
        }
    }
}
