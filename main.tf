terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.9.0"
    }
  }
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "pbazure"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "gcp-vertexai"
    }
  }
}

variable "GOOGLECREDENTIALS" {
  type = string
}

variable "PROJECT_NUMBER" {
  type = number
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS

  project = var.PROJECT_NUMBER
  region  = "us-central1"
  zone    = "us-central1-c"
}
