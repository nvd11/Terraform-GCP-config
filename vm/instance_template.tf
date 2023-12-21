resource "google_compute_instance_template" "vm-template-vpc0-subnet0-e2-small-tomcat" {
  name         = "vm-template-vpc0-subnet0-e2-small-tomcat"
  machine_type = "e2-small"

  disk {
    source_image = "https://compute.googleapis.com/compute/v1/projects/jason-hsbc/global/images/e2-small-tomcat-image"
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  network_interface {
    network =  var.vpc0
    subnetwork =  var.vpc0_subnet0    
  }

 service_account {
    email  = "vm-common@jason-hsbc.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#provisioning_model
  # to reduce cost
  scheduling { 
    automatic_restart = false # Scheduling must have preemptible be false when AutomaticRestart is true.
    provisioning_model = "SPOT"
    preemptible         = true
    instance_termination_action = "STOP"
  }

  can_ip_forward = false
}
