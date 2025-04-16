# 🚀 Kubenetes with GitOps project

AWS EKS Infrastructure and application deployment using **Terraform**, **Helm**, **NGINX Ingress Controller** and **ArgoCD**.

---

## 📦 Tech Stack

| Tool        | Purpose                                      |
|-------------|----------------------------------------------|
| Terraform   | Infrastructure provisioning (EKS cluster, Ingress Nginx, ArgoCD)   |
| Kubernetes  | Container orchestration                      |
| Helm        | Package management and for kubernetes    |
| NGINX Ingress | Ingress controller for routing to service       |
| ArgoCD | Automate the deployment and lifecycle management of applications running on Kubernetes clusters   |
---

## Overview

This project leverages a modern cloud-native technology stack to provision and manage the infrastructure required to run our application. We utilize Terraform for Infrastructure as Code (IaC), Kubernetes as the container orchestration platform, Helm as the Kubernetes package manager, and Nginx Ingress as the entry point for external traffic.

This README provides an overview of the technologies used, the project structure, and instructions for setting up and managing the infrastructure.

## Technology Stack

* **Terraform:** An open-source infrastructure as code (IaC) software tool that allows you to define and provision infrastructure using a declarative configuration language. We use Terraform to provision the underlying cloud resources necessary for our Kubernetes cluster and other dependencies.

* **Kubernetes:** A portable, extensible, open-source platform for managing containerized workloads and services. Kubernetes automates the deployment, scaling, and management of containerized applications.

* **Helm:** A package manager for Kubernetes. Helm charts define, install, and upgrade even the most complex Kubernetes applications. We use Helm to package and deploy our application and its dependencies within the Kubernetes cluster.

* **Nginx Ingress Controller:** An Ingress controller that uses Nginx as a reverse proxy and load balancer. It provides HTTP and HTTPS routing from outside the cluster to services within the Kubernetes cluster based on rules defined in Ingress resources.

* **ArgoCD:** GitOps-based continuous delivery tool for Kubernetes. It helps you automate the deployment and lifecycle management of applications running on Kubernetes clusters.


## Prerequisites

Before you begin, ensure you have the following tools installed and configured:

* **Terraform:** [Installation Guide](https://developer.hashicorp.com/terraform/install)
* **kubectl:** [Installation Guide](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
* **Helm:** [Installation Guide](https://helm.sh/docs/intro/install/)
* **AWS CLI:** [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


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
    Once the Kubernetes cluster is provisioned, you will need to authenticate with EKS cluster using `AWS CLI`.
    Authentication & Authorization: It uses your AWS credentials to authenticate with EKS and fetch details about the specified cluster.
     ```bash
    aws eks update-kubeconfig \
    --region us-east-1 \
    --name dev-cluster
    ```

5.  **Create EKS resource and ArgoCD with bash script:**
    Navigate to the `kubernetes/script` directory and execute bash script.
    ```bash
    cd ../kubernetes/script
    ./script.sh
    ```

6.  **Verify kubernetes resource in webapp namespace after create with bash script:**
    Verify deployment, service and pod is running.
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
8.  **Initialize ArgoCD application:**

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

9.  **Test ArgoCD application:**

    Edit replicas from 1 to 2 in deployment.yaml, wait 3 minutes or manual sync.
    Nginx pod in `service name nginx` will increase to 2.


8.  **Clean up project:**

    Delete kubernetes webapp namespace.

     ```bash
    kubectl delete ns webapp
    terraform init
    ```
    Delete EKS resource with terraform.

    ```bash
    cd terraform
    terraform destroy -auto-approve
    ```