terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = "~> 5.0"
  }
}

provider "aws" {
  region = var.region
}