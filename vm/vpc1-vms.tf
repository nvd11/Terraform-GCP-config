






# this vm is under tf-vpc1 subnet 0, for vpc connectivity testing
resource "google_compute_instance" "tf-vpc1-subnet0-vm0" {
  name         = "tf-vpc1-subnet0-vm0"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "e2-small" # 0.5-2 vCPU (1 shared core) , 2GB Mem
  
  boot_disk {
   initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }
  
  network_interface {
    network =  var.vpc1
    subnetwork =  var.vpc1_subnet0
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




