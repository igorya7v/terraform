#----------------------------------------------------------
# Provision an Apache WebServer on GCP Platform
#-----------------------------------------------------------
provider "google" {
  project = "eminent-maker-293204"
  region  = "us-west1"
  zone    = "us-west1-c"
}

# Enable the needed APIs
resource "google_project_service" "api" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  disable_on_destroy = true
  service            = each.value
}

# Enable HTTP/S
resource "google_compute_firewall" "web" {
  name          = "web-access"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

# Compute Instance Config
resource "google_compute_instance" "web_server" {
  name         = "gcp-web-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    # Enable Public IP Address
    access_config {}
  }
  #metadata_startup_script = file("startup-script.sh")
  metadata_startup_script = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo echo "<h2>"WebServer Provisioned by Terraform"<h2>"  >  /var/www/html/index.html
sudo systemctl restart apache2
EOF

  depends_on = [google_project_service.api, google_compute_firewall.web]
}
