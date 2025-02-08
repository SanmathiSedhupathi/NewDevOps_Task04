#!/bin/bash

# Exit on error
set -e

# Set the correct kubeconfig if needed (Adjust path as necessary)
export KUBECONFIG=$HOME/.kube/config  # Update path if required

# Ensure Minikube context is selected
echo "🔄 Switching to Minikube context..."
kubectl config use-context minikube

# Docker build process
echo "⚙️ Building the Docker image..."
docker build -t sanmathisedhupathi/devopstask04 .

# Docker login securely
echo "🔑 Logging in to Docker Hub..."
echo "08-Sep-2004" | docker login -u "sanmathisedhupathi" --password-stdin
docker tag devopstask04 sanmathisedhupathi/devopstask04
# Push the new image
echo "🚀 Pushing the Docker image to Docker Hub..."
docker push sanmathisedhupathi/devopstask04

# Deploy to Minikube without using a separate YAML file
echo "📦 Deploying to Minikube..."

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devopstask04
spec:
  replicas: 1
  selector:
    matchLabels:
      app: devopstask04
  template:
    metadata:
      labels:
        app: devopstask04
    spec:
      containers:
        - name: devopstask04
          image: sanmathisedhupathi/devopstask04
          ports:
            - containerPort: 80
EOF
echo "🔌 Exposing the deployment as a service..."
kubectl expose deployment devopstask04 --type=NodePort --name=devopstask04-service --port=80 --target-port=80 --name=devopstask04-service
echo "✅ Deployment completed successfully!"
