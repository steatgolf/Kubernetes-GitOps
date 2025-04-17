#!/bin/bash

# Fail on error and undefined variables
set -euo pipefail

#Navigate to manifest file directory
cd ..

# Create namespace, deployment, service, ingress and ArgoCD application
kubectl apply -f 1-namespace.yaml

kubectl apply -f 2-deployment.yaml
kubectl apply -f dev-deployment.yaml

kubectl apply -f 3-service.yaml
kubectl apply -f dev-service.yaml

kubectl apply -f 4-ingress.yaml

kubectl apply -f 5-argocd.yaml