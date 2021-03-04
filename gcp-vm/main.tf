provider "google" {
  project = "eminent-maker-293204"
  region  = "us-west1"
  zone    = "us-west1-c"
}

resource "google_compute_instance" "some_server" {
  name         = "simple-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    # Enable Public IP
    access_config {}
  }
}
