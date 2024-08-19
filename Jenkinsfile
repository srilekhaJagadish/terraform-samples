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
                aws_credentials=$(aws sts assume-role --role-arn arn:aws:iam::533267077438:role/deployer-role --role-session-name "RoleSession1" --output json)

                export AWS_ACCESS_KEY_ID=$(echo $aws_credentials|jq '.Credentials.AccessKeyId'|tr -d '"')
                export AWS_SECRET_ACCESS_KEY=$(echo $aws_credentials|jq '.Credentials.SecretAccessKey'|tr -d '"')
                export AWS_SESSION_TOKEN=$(echo $aws_credentials|jq '.Credentials.SessionToken'|tr -d '"')
                terraform init 
                terraform plan 
                terraform apply -auto-approve
                '''
            }
        }
    }
}
