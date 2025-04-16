# 🚀 Kubenetes with GitOps project

Infrastructure and application deployment using **Terraform**, **Kubernetes**, **Helm**, and **NGINX Ingress Controller**.

---

## 📦 Tech Stack

| Tool        | Purpose                                      |
|-------------|----------------------------------------------|
| Terraform   | Infrastructure provisioning (EKS, Ingress Nginx, ArgoCD)   |
| Kubernetes  | Container orchestration                      |
| Helm        | Package management and templating for K8s    |
| NGINX Ingress | Ingress controller for routing to service       |

---

## 🧭 Project Structure

---

# Project Title

**A robust and scalable application infrastructure managed with Terraform, Kubernetes, Helm, and Nginx Ingress.**

## Overview

This project leverages a modern cloud-native technology stack to provision and manage the infrastructure required to run our application. We utilize Terraform for Infrastructure as Code (IaC), Kubernetes as the container orchestration platform, Helm as the Kubernetes package manager, and Nginx Ingress as the entry point for external traffic.

This README provides an overview of the technologies used, the project structure, and instructions for setting up and managing the infrastructure.

## Technology Stack

* **Terraform:** An open-source infrastructure as code (IaC) software tool that allows you to define and provision infrastructure using a declarative configuration language. We use Terraform to provision the underlying cloud resources necessary for our Kubernetes cluster and other dependencies.
* **Kubernetes (k8s):** A portable, extensible, open-source platform for managing containerized workloads and services. Kubernetes automates the deployment, scaling, and management of containerized applications.
* **Helm:** A package manager for Kubernetes. Helm charts define, install, and upgrade even the most complex Kubernetes applications. We use Helm to package and deploy our application and its dependencies within the Kubernetes cluster.
* **Nginx Ingress Controller:** An Ingress controller that uses Nginx as a reverse proxy and load balancer. It provides HTTP and HTTPS routing from outside the cluster to services within the Kubernetes cluster based on rules defined in Ingress resources.

## Project Structure



├── terraform/        # Terraform configurations for infrastructure provisioning
│   ├── main.tf       # Main Terraform configuration
│   ├── variables.tf  # Define input variables for Terraform
│   ├── outputs.tf    # Define output values from Terraform
│   ├── providers.tf  # Define the cloud providers used
│   └── ...           # Other Terraform modules and configurations
├── kubernetes/       # Kubernetes manifests and configurations
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ...           # Other Kubernetes resource definitions
├── helm/             # Helm chart for deploying the application
│   ├── Chart.yaml    # Metadata about the Helm chart
│   ├── values.yaml   # Default configuration values for the chart
│   ├── templates/    # Kubernetes manifest templates
│   └── ...           # Other Helm chart files
├── ingress/          # Kubernetes Ingress configurations
│   └── nginx-ingress.yaml # Ingress resource definition for Nginx
├── README.md         # This file
└── ...               # Other project-related files



---

├── kubernetes
│   ├── 1-namespace.yaml    # Create Kubernetes webapp namespace
│   ├── 2-deployment.yaml
│   ├── 3-service.yaml
│   ├── 4-ingress.yaml
│   ├── 5-argocd.yaml
│   ├── dev-deployment.yaml
│   ├── dev-service.yaml
│   └── script
│       └── script.sh
└── terraform               # Terraform configurations for infrastructure provisioning
    ├── 0-local.tf          # local variable
    ├── 1-network.tf        # Create network object for EKS cluster
    ├── 2-eks.tf            # Create EKS Cluster, worker node and IAM role
    ├── 3-helm.tf           # Create Nginx ingress and ArgoCD application
    ├── provider.tf         # Define the cloud providers used
    └── values
        └── argocd.yaml     # Define custom values for ArgoCD application


## Prerequisites

Before you begin, ensure you have the following tools installed and configured:

* **Terraform:** [Installation Guide](https://developer.hashicorp.com/terraform/downloads)
* **kubectl:** The Kubernetes command-line tool. [Installation Guide](https://kubernetes.io/docs/tasks/tools/)
* **Helm:** The Kubernetes package manager. [Installation Guide](https://helm.sh/docs/intro/install/)
* **Cloud Provider CLI:** (e.g., AWS CLI, Azure CLI, gcloud CLI) configured with the necessary credentials to provision resources on your chosen cloud provider.

## Getting Started

Follow these steps to set up the infrastructure:

1.  **Initialize Terraform:**
    ```bash
    cd terraform
    terraform init
    ```

2.  **Plan Terraform Infrastructure:**
    ```bash
    terraform plan
    ```
    Review the output carefully to understand the resources that will be created.

3.  **Apply Terraform Infrastructure:**
    ```bash
    terraform apply -auto-approve
    ```
    This command will provision the necessary infrastructure on your cloud provider, including the Kubernetes cluster.

4.  **Authenticate with EKS cluster:**
    Once the Kubernetes cluster is provisioned, you will need to authenticate with EKS cluster using `AWS cli`.
    Authentication & Authorization: It uses your AWS credentials to authenticate with EKS and fetch details about the specified cluster.
     ```bash
    aws eks update-kubeconfig \
    --region us-east-1 \
    --name dev-cluster
    ```

5.  **Create EKS infrastructure and ArgoCD with bash script:**
    Navigate to the `kubernetes/script` directory and execute bash script.
    ```bash
    cd ../kubernetes/script
    ./script.sh
    ```

6.  **Verify kubernetes infrastructure in webapp namespace after create with bash script:**
    Verify deployment, service and pod is running
    ```bash
    kubectl get all -n webapp
    ```

7.  **Test routing to kubernetes service:**

    Get AWS load balance hostname or IP Address.
    ```bash
    kubectl descripe ingress -n webapp
    ```

    Test with curl command with source host = web.example.com (Route to nginx service port 80 )
    ```bash
    curl -i --header "Host: web.example.com" http://aff6168619c6a429b8e1e4b660a00173-1339339846.us-east-1.elb.amazonaws.com
    ```

    Test with curl command with source host = dev.web.example.com (Route to dev-nginx service port 80 )
    ```bash
    curl -i --header "Host: dev.web.example.com" http://aff6168619c6a429b8e1e4b660a00173-1339339846.us-east-1.elb.amazonaws.com
    ```
8.  **Configure ArgoCD application:**

    Get ArgoCD password from Kubernetes secrets.
    ```bash
    kubectl get secrets argocd-initial-admin-secret -o yaml -n argocd
    ```

    Decode ArgoCD password.
    ```bash
    echo "<password before decode>" | base64 --decode
    ```

    Forward port argocd service and login with username `admin` and password in previous step.
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:80
    ```

8.  **Test ArgoCD application:**

    Edit replicas from 1 to 2 in deployment.yaml and wait 3 minutes or manual sync
