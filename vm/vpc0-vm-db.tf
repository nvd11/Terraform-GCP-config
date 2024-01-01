# this vm is under tf-vpc0 subnet 0, for vpc connectivity testing
resource "google_compute_instance" "tf-vpc0-subnet0-mysql0" {
  name         = "tf-vpc0-subnet0-mysql0"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "e2-standard-2" # 2 vcpu 8GB Mem
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-focal-v20231213a"
      size  = 20
    }
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

}