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
docker build -t mohamedathikr/devopstask04 .

# Docker login securely
echo "🔑 Logging in to Docker Hub..."
echo "qwerty786!A" | docker login -u "mohamedathikr" --password-stdin

# Push the new image
echo "🚀 Pushing the Docker image to Docker Hub..."
docker push mohamedathikr/devopstask04

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
          image: mohamedathikr/devopstask04
          ports:
            - containerPort: 80
EOF

echo "✅ Deployment completed successfully!"
