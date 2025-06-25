# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_template
# https://developer.hashicorp.com/terraform/language/functions/file
# Google Compute Engine: Regional Instance Template
resource "google_compute_region_instance_template" "region_a" {
  name         = "instance-template"
  machine_type = "n2-standard-4"


  # Create a new disk from an image and set as boot disk
  disk {
    source_image = "debian-cloud/debian-12"
    boot         = true
  }

  # Network Configurations 
  network_interface {
    subnetwork = google_compute_subnetwork.region_a.id
    access_config {
      # Include this section to give the VM an external IP address
    } 
  }
}

resource "google_compute_instance_from_template" "master" {
  name = "kubemaster"
  zone = "us-central1-a"

  source_instance_template = google_compute_region_instance_template.region_a.self_link
  
}

resource "google_compute_instance_from_template" "tpl" {
  count = 3
  name = "kubenode0${count.index + 1}"
  zone = "us-central1-a"

  source_instance_template = google_compute_region_instance_template.region_a.self_link
  
}