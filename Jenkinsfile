pipeline {
    agent any

    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        MINIKUBE_HOME = "/var/lib/jenkins/.minikube"
    }

    stages {
        stage('Setup Minikube Context') {
            steps {
                script {
                    sh '''
                    set -e  # Exit on error

                    echo "🔄 Switching to Minikube context..."
                    kubectl config use-context minikube
                    echo "✅ Minikube context set successfully!"
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    sh '''
                    set -e  # Exit on error

                    echo "🚀 Deploying Application..."
                    kubectl apply -f deployment.yaml --validate=false
                    '''
                }
            }
        }
    }
}
