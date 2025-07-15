# AryaXAI Microservice Pipeline

This repository contains an end-to-end production pipeline for a FastAPI-based microservice deployed on a publicly accessible AWS EKS cluster using Terraform, Docker, Helm, and GitHub Actions.

## Prerequisites

- **AWS Account**: Configured with programmatic access (Access Key ID and Secret Access Key).
- **Docker Hub Account**: For storing the `demo_image:latest` image.
- **GitHub Repository**: With secrets configured for CI/CD.
- **Local Tools**:
  - Terraform (>= 1.9.0)
  - Helm (>= 3.16.0)
  - kubectl (>= 1.31.0)
  - AWS CLI
  - Python 3.12
- **Local Kubernetes Cluster** (optional): For local testing (e.g., `kind` or `minikube`).

## Repository Structure

aryaxai-microservice-pipeline/├── app/                  # FastAPI application code and tests├── terraform/            # Terraform code for EKS cluster├── helm/                 # Helm chart for application deployment├── .github/workflows/    # GitHub Actions CI/CD pipeline├── Dockerfile            # Multi-stage Dockerfile├── DESIGN.md             # Observability strategy├── README.md             # This operational runbook

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/aryaxai-microservice-pipeline.git
cd aryaxai-microservice-pipeline

2. Configure AWS Credentials
Set up AWS CLI with your credentials:
aws configure

3. Provision Public EKS Cluster
Navigate to the terraform/ directory and deploy the publicly accessible EKS cluster:
cd terraform
terraform init
terraform apply -var="region=us-west-2" -var="cluster_name=aryaxai-eks"

After Terraform applies, configure kubectl using the output kubeconfig command:
aws eks update-kubeconfig --region us-west-2 --name aryaxai-eks

4. Configure GitHub Secrets
Add the following secrets in your GitHub repository settings (Settings > Secrets and variables > Actions):

DOCKER_USERNAME: Your Docker Hub username
DOCKER_PASSWORD: Your Docker Hub password
AWS_ACCESS_KEY_ID: AWS access key
AWS_SECRET_ACCESS_KEY: AWS secret key

5. Build and Test Locally
Install Python dependencies and run tests:
cd app
pip install -r requirements.txt
pytest tests

6. Build Docker Image
Build and push the Docker image to Docker Hub:
docker build -t yourusername/demo_image:latest .
docker push yourusername/demo_image:latest

Replace yourusername with your Docker Hub username.
7. Deploy Helm Chart Locally
Deploy the application to your local Kubernetes cluster or EKS using Helm:
helm upgrade --install aryaxai-app ./helm \
  --set image.repository=yourusername/demo_image \
  --set image.tag=latest \
  --namespace default

Replace yourusername with your Docker Hub username.
8. CI/CD Pipeline
The GitHub Actions workflow (.github/workflows/ci-cd.yml) automatically:

Lints the code with flake8
Runs unit tests with pytest
Builds and pushes the Docker image to Docker Hub
Deploys to EKS using Helm

Trigger the pipeline by pushing to the main branch:
git add .
git commit -m "Deploy microservice"
git push origin main

9. Verify Deployment
Check the deployment status:
kubectl get pods
kubectl get svc aryaxai-app

Access the application locally via port-forwarding:
kubectl port-forward svc/aryaxai-app 8080:80

Open http://localhost:8080 in your browser to see the "Hello, World!" response.
For external access on EKS, modify helm/values.yaml to use service.type=LoadBalancer, redeploy, and get the load balancer URL:
kubectl get svc aryaxai-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

10. Observability
Refer to DESIGN.md for the observability strategy, including:

Metrics: Prometheus and Grafana for latency, error rate, etc.
Logging: Loki and Promtail for log aggregation.
Tracing: OpenTelemetry and Jaeger for distributed tracing.

Cleanup
To destroy the EKS cluster:
cd terraform
terraform destroy -var="region=us-west-2" -var="cluster_name=aryaxai-eks"

Notes

Replace yourusername in helm/values.yaml and .github/workflows/ci-cd.yml with your Docker Hub username.
The EKS cluster API is publicly accessible (cluster_endpoint_public_access = true). Restrict cluster_endpoint_public_access_cidrs in terraform/main.tf for production (e.g., ["your.ip.range/24"]).
Ensure AWS credentials have permissions for EKS, EC2, VPC, and IAM.
The Helm chart is configurable via helm/values.yaml for replicas, resources, etc.
For local testing, use kind or minikube if you don’t want to provision EKS.


