# AryaXAI Microservice Pipeline

This repository contains an end-to-end production pipeline for a FastAPI-based microservice deployed on a publicly accessible AWS EKS cluster using Terraform, Docker, Helm, and GitHub Actions.

## Prerequisites

- **AWS Account**: Configured with programmatic access (Access Key ID and Secret Access Key).
- **GitHub Repository**: With secrets configured for CI/CD.
- **Local Tools**:
  - Terraform (>= 1.5.3)
  - Helm (>= 3.16.0)
  - kubectl (>= 1.31.0)
  - AWS CLI
  - Python 3.12
- **Local Kubernetes Cluster** (optional): For local testing (e.g., `kind` or `minikube`).

## Setup Instructions

This repository contains a Python-based microservice application deployed using a fully automated **CI/CD pipeline** built with **GitHub Actions**. The pipeline performs linting, testing, Docker image creation, pushes to **GitHub Container Registry (GHCR)**, and deploys to an **Amazon EKS** cluster using **Helm**.

---

## 📌 Key Features

- ✅ Auto-triggered on push to the `main` branch
- ✅ Python linting with `flake8`
- ✅ Unit testing with `pytest`
- ✅ Docker image build and push to GHCR
- ✅ Secure build attestation
- ✅ Deployment to AWS EKS via Helm

---

## 🛠️ CI/CD Pipeline Overview

### 📁 Trigger

The workflow is triggered automatically whenever a push is made to the `main` branch:

```yaml
on:
  push:
    branches:
      - main


