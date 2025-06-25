output "kubenode" {
  value = [
    for idx, instance in google_compute_instance_from_template.tpl : {
      name           = instance.name
      vm_internal_ip = instance.network_interface[0].network_ip
      vm_external_ip = instance.network_interface[0].access_config[0].nat_ip
      ssh_command    = "gcloud compute ssh ${instance.name} --zone=${instance.zone}"
    }
  ]
}

output "kubemaster" {
  value =  {
      name           = google_compute_instance_from_template.master.name
      vm_internal_ip = google_compute_instance_from_template.master.network_interface[0].network_ip
      vm_external_ip = google_compute_instance_from_template.master.network_interface[0].access_config[0].nat_ip
      ssh_command    = "gcloud compute ssh ${google_compute_instance_from_template.master.name} --zone=${google_compute_instance_from_template.master.zone}"
    }
}
