pipeline {
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myimage:latest .'
            }
        }

        stage('Push to ECR') {
            steps {
                withAWS(region: 'us-west-2', credentials: 'aws-creds') {
                    sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin myregistry/myimage'
                    sh 'docker tag myimage:latest myregistry/myimage:latest'
                    sh 'docker push myregistry/myimage:latest'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://cluster-api.us-west-2.amazonaws.com']) {
                    sh 'kubectl apply -f k8s/'
                }
            }
        }
    }
}
