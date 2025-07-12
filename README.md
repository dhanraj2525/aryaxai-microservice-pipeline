AryaXAI Microservice Pipeline

This repository contains an end-to-end production pipeline for a FastAPI-based microservice deployed on AWS EKS using Terraform, Docker, Helm, and GitHub Actions.

Prerequisites





AWS account with programmatic access (Access Key ID and Secret Access Key)



Docker Hub account



GitHub repository with secrets configured



Terraform (>= 1.9.0)



Helm (>= 3.16.0)



kubectl (>= 1.31.0)



Python 3.12

Setup Instructions

1. Clone the Repository

git clone https://github.com/yourusername/aryaxai-microservice-pipeline.git
cd aryaxai-microservice-pipeline

2. Configure AWS Credentials

Set up AWS CLI and configure credentials:

aws configure

3. Provision EKS Cluster

Navigate to the terraform/ directory and deploy the EKS cluster:

cd terraform
terraform init
terraform apply -var="region=us-west-2" -var="cluster_name=aryaxai-eks"

After completion, run the output kubeconfig command to configure kubectl:

aws eks update-kubeconfig --region us-west-2 --name aryaxai-eks

4. Configure GitHub Secrets

Add the following secrets in your GitHub repository settings:





DOCKER_USERNAME: Your Docker Hub username



DOCKER_PASSWORD: Your Docker Hub password



AWS_ACCESS_KEY_ID: AWS access key



AWS_SECRET_ACCESS_KEY: AWS secret key

5. Build and Test Locally

Install Python dependencies and run tests:

cd app
pip install -r requirements.txt
pytest tests

6. Deploy Helm Chart Locally

Deploy the application to EKS using Helm:

helm upgrade --install aryaxai-app ./helm \
  --set image.repository=yourusername/aryaxai-app \
  --set image.tag=latest \
  --namespace default

7. CI/CD Pipeline

The GitHub Actions workflow (.github/workflows/ci-cd.yml) automatically:





Lints the code with flake8



Runs unit tests with pytest



Builds and pushes the Docker image to Docker Hub



Deploys the application to EKS using Helm

Push changes to the main branch to trigger the pipeline:

git add .
git commit -m "Initial commit"
git push origin main

8. Verify Deployment

Check the deployment status:

kubectl get pods
kubectl get svc aryaxai-app

Access the application via the service's ClusterIP or set up an Ingress for external access.

9. Observability

Refer to DESIGN.md for the observability strategy, including metrics (Prometheus/Grafana), logging (Loki/Promtail), and tracing (OpenTelemetry/Jaeger).

Cleanup

To destroy the EKS cluster:

cd terraform
terraform destroy

Notes





Replace yourusername with your Docker Hub username in values.yaml and CI/CD workflow.



Ensure AWS credentials have permissions for EKS, EC2, VPC, and IAM.



The Helm chart is configurable via values.yaml for replicas, resource limits, and more.