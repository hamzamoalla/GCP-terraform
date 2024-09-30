provider "google" {
  region = "europe-west3"  # GCP region for Frankfurt
  project = ""  # Replace with your Google Cloud project ID
}

variable "cidr_blocks" {
  description = "CIDR blocks and name tags for VPC and subnets"
  type        = list(object({
    cidr_block = string
    name       = string
  }))
}

variable "avail_zone" {
  default = "europe-west3-a"  # GCP availability zone
}

resource "google_compute_network" "myapp_vpc" {
  name = var.cidr_blocks[0].name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "myapp_subnet_1" {
  name          = var.cidr_blocks[1].name
  ip_cidr_range = var.cidr_blocks[1].cidr_block
  region        = var.avail_zone
  network       = google_compute_network.myapp_vpc.id
}

output "dev_vpc_id" {
  value = google_compute_network.myapp_vpc.id
}

output "dev_subnet_id" {
  value = google_compute_subnetwork.myapp_subnet_1.id
}

data "google_compute_network" "existing_vpc" {
  name = "default"  # GCP's default network
}

resource "google_compute_subnetwork" "dev_subnet_2" {
  name          = "subnet-2-default"
  ip_cidr_range = "172.31.48.0/20"
  region        = "europe-west3-a"
  network       = data.google_compute_network.existing_vpc.id
}
