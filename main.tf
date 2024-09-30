provider "google" {
  project = var.project_id
  region  = var.region
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}
variable "project_id" {}
variable "region" {}

resource "google_compute_network" "myapp-vpc" {
  name = "${var.env_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "myapp-subnet-1" {
  name          = "${var.env_prefix}-subnet-1"
  ip_cidr_range = var.subnet_cidr_block
  network       = google_compute_network.myapp-vpc.id
  region        = var.region
}

resource "google_compute_router" "myapp-router" {
  name    = "${var.env_prefix}-router"
  network = google_compute_network.myapp-vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "myapp-nat" {
  name                               = "${var.env_prefix}-nat"
  router                             = google_compute_router.myapp-router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = ["ALL_SUBNETWORKS_ALL_IP_RANGES"]
}

resource "google_compute_firewall" "default-sg" {
  name    = "${var.env_prefix}-firewall"
  network = google_compute_network.myapp-vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = [var.my_ip, "0.0.0.0/0"]

  target_tags = ["allow-ssh-http"]
}

data "google_compute_image" "latest-gcp-linux-image" {
  family  = "debian-11"
  project = "debian-cloud"
}

output "gcp_image_id" {
  value = data.google_compute_image.latest-gcp-linux-image.id
}

output "ec2_public_ip" {
  value = google_compute_instance.myapp-server.network_interface[0].access_config[0].nat_ip
}

resource "google_compute_instance" "myapp-server" {
  name         = "${var.env_prefix}-server"
  machine_type = var.instance_type
  zone         = var.avail_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.latest-gcp-linux-image.id
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.myapp-subnet-1.id
    access_config {}
  }

  metadata = {
    ssh-keys = "username:${file(var.public_key_location)}"
  }

  tags = ["allow-ssh-http"]

  metadata_startup_script = file("entry-script.sh")

  service_account {
    scopes = ["cloud-platform"]
  }
}
