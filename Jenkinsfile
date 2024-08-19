pipeline {
    agent any

    stages {
        stage('Deploy') {
            steps {
                sh '''
                cd aws-resources
                pwd
                ls
                set +x
                aws_credentials=$(aws sts assume-role --role-arn arn:aws:iam::533267077438:role/deployer-role --role-session-name "RoleSession1" --output json)

                export AWS_ACCESS_KEY_ID=$(echo $aws_credentials|jq '.Credentials.AccessKeyId'|tr -d '"')
                export AWS_SECRET_ACCESS_KEY=$(echo $aws_credentials|jq '.Credentials.SecretAccessKey'|tr -d '"')
                export AWS_SESSION_TOKEN=$(echo $aws_credentials|jq '.Credentials.SessionToken'|tr -d '"')
                echo 'terraform init ....'
                terraform init 
                echo 'terraform plan ....'
                terraform plan terraform plan -out=webServerTfplan.tfplan
                echo 'terraform show ....'
                terraform show webServerTfplan.tfplan
                echo 'terraform apply ....'
                terraform apply webServerTfplan.tfplan
                '''
            }
        }
    }
}
