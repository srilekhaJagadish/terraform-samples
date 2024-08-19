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
                '''
            }
        }
    }
}
