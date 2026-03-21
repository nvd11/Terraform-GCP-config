# create a vm with gpu attached, to test deepseek installation
resource "google_compute_instance" "tf-vpc0-subnet0-gpu-vm0" {
  name         = "tf-vpc0-subnet0-gpu-vm0"
  project  = var.project_id
  zone = "europe-west2-a"
  
  allow_stopping_for_update = true
  machine_type = "n1-highmem-8" # 8 vCPUs, 52 GB memory
  
  boot_disk {
   initialize_params {
      image = "debian-cloud/debian-11"
      size  = 500
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

  # gpu setup
  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = 1
  }

  metadata = {
    "install-nvidia-driver" = "true"
  }

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#provisioning_model
  # to reduce cost
  scheduling { 
    on_host_maintenance = "TERMINATE" # means the instance will be terminated when there is a maintenance event
                                      # it's must for gpu instances
    automatic_restart = false # Scheduling must have preemptible be false when AutomaticRestart is true.
    provisioning_model = "SPOT"
    preemptible         = true
    instance_termination_action = "STOP"
  }

}
