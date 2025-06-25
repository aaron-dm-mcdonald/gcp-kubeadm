# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall


resource "google_compute_firewall" "ssh" {
  name    = "${google_compute_network.app.name}-allow-ssh"
  network = google_compute_network.app.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "web-traffic" {
  name    = "${google_compute_network.app.name}-allow-web-traffic"
  network = google_compute_network.app.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Lizzo's ping FW rule
resource "google_compute_firewall" "ping" {
  name    = "${google_compute_network.app.name}-allow-ping"
  network = google_compute_network.app.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Internal allow-all firewall rule
resource "google_compute_firewall" "internal_allow_all" {
  name    = "${google_compute_network.app.name}-allow-internal-all"
  network = google_compute_network.app.name

  allow {
    protocol = "all"
  }

  # Replace with your actual VPC CIDR range
  source_ranges = [ google_compute_subnetwork.region_a.ip_cidr_range ]
}


resource "google_compute_firewall" "api-traffic" {
  name    = "${google_compute_network.app.name}-allow-api-traffic"
  network = google_compute_network.app.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}