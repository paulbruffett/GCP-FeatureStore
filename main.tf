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


resource "google_bigquery_dataset" "sensordata" {
  dataset_id                  = "sensor_data"
  friendly_name               = "sensorreadings"
  location                    = "us-east1"

    access {
    role = "OWNER"
    user_by_email = "terraform@testvertex-360003.iam.gserviceaccount.com"
  }
}

resource "google_bigquery_table" "arduinoreadings_timestamp" {
  dataset_id = google_bigquery_dataset.sensordata.dataset_id
  table_id   = "arduino_prepared"


  schema = <<EOF
[
  {
    "name": "timestamp",
    "type": "DATETIME",
    "mode": "NULLABLE"
  },
  {
    "name": "temp",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "humidity",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "pressure",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
    {
    "name": "illuminance",
    "type": "FLOAT",
    "mode": "NULLABLE"
  }
]
EOF

}