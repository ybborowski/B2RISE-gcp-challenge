provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_service_account" "api_sa" {
  account_id   = "api-pubsub-sa"
  display_name = "Service Account for Pub/Sub Access"
}

resource "google_project_iam_member" "pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.api_sa.email}"
}

resource "google_project_iam_member" "pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.api_sa.email}"
}

resource "google_compute_network" "vpc_network" {
  name = "my-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "vm_instance" {
  name         = "typescript-api-vm"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["http-server", "ssh-server"]

  service_account {
    email  = google_service_account.api_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  target_tags = ["http-server"]

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh-server"]
}

resource "google_pubsub_topic" "api_topic" {
  name = "api-topic"
}

resource "google_pubsub_subscription" "api_subscription" {
  name  = "api-subscription"
  topic = google_pubsub_topic.api_topic.name
}
