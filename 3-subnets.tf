# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

resource "google_compute_subnetwork" "region_a" {
  name                     = "subnet"
  ip_cidr_range            = "192.168.56.0/24"
  network                  = google_compute_network.app.id
  private_ip_google_access = false
}

