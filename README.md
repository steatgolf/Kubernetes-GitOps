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

This project leverages a modern cloud-native technology stack to provision and manage the infrastructure required to run nginx web application. We utilize Terraform for Infrastructure as Code (IaC), Kubernetes as the container orchestration platform, Helm as the Kubernetes package manager, Nginx Ingress as the entry point for external traffic and ArgoCD for automate the deployment and lifecycle management.

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

1.  **Initialize Terraform**
    ```bash
    cd terraform
    terraform init
    ```

2.  **Plan Terraform Infrastructure**
    ```bash
    terraform plan
    ```
    Review the output carefully to understand the resources that will be created.

3.  **Apply Terraform Infrastructure**
    ```bash
    terraform apply -auto-approve
    ```
    This command will provision the necessary infrastructure on AWS cloud provider, including the Kubernetes cluster.

4.  **Authenticate with EKS cluster**

    Once the cluster is created, authenticate with EKS using the `AWS CLI` specified cluster.

     ```bash
    aws eks update-kubeconfig \
    --region us-east-1 \
    --name dev-cluster
    ```

5.  **Create EKS resource and ArgoCD with bash script**

    Run the setup script located in the `kubernetes/script` directory.
    ```bash
    cd ../kubernetes/script
    ./provision_script.sh
    ```

6.  **Verify kubernetes resource in webapp namespace**

    Ensure the application components (Deployments, Services, Pods) are running.
    ```bash
    kubectl get all -n webapp
    ```

7.  **Test external access via Nginx ingress**

    Retrieve the AWS Load Balancer hostname or IP.
    ```bash
    kubectl descripe ingress -n webapp
    ```
    Test routing with `curl` using the appropriate host headers. `host = web.example.com` (Route to nginx service port 80)
    ```bash
    curl -i --header "Host: web.example.com" http://<loadbalance name or ip address>
    ```

    Test routing with `curl` using the appropriate host headers. `host = dev.web.example.com` (Route to nginx service port 80)
    ```bash
    curl -i --header "Host: dev.web.example.com" http://<loadbalance name or ip address>
    ```
8.  **Access ArgoCD application**

    Retrieve the Argo CD admin password from kubernetes secrets.

    ```bash
    kubectl get secrets argocd-initial-admin-secret -o yaml -n argocd
    ```

    Decode the password.
    ```bash
    echo "<password before decode>" | base64 --decode
    ```

    Port-forward to access the Argo CD UI.
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:80
    ```
    Access Argo CD at http://localhost:8080 and login using the username `admin` and the `decoded password`.

9.  **Test ArgoCD application**

    Modify deployment.yaml to change the number of replicas from 1 to 2. Wait a few minutes or manually trigger a sync in the Argo CD UI. You should see the number of nginx pods in `service name nginx` increase accordingly.

10. **Clean up**
    
    Delete Kebernetes `webapp` namesapce.

    ```bash
    kubectl delete ns webapp
    ```

    Destroy terraform infrastructure.

     ```bash
    cd terraform
    terraform destroy -auto-approve
    ```
