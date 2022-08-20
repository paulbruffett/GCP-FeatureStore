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
      name = "vertexai"
    }
  }
}

variable "GOOGLECREDENTIALS" {
  type = string
}

variable "PROJECTNUMBER" {
  type = number
}

provider "google" {
  credentials = var.GOOGLECREDENTIALS

  project = var.PROJECTNUMBER
  region  = "us-central1"
  zone    = "us-central1-c"
}


resource "google_storage_bucket" "gcs-temp" {
    name          = "pb-temp-gcs"
    location      = "US"
    force_destroy = true
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}