resource "google_compute_address" "static_ip" {
  name = "gcp-vm"
}

resource "google_compute_network" "vpc_network" {
  name = "my-gcp-network"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.vpc_network.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "5000"]
  }

}

data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "gcp_vm" {
  name         = "gcp-vm"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"]

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
#    startup-script = <<-EOF
#  sudo apt update
#  sudo apt install -y docker.io
#  sudo apt install -y docker-compose
#  sudo usermod -aG docker $USER
#  EOF
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
}