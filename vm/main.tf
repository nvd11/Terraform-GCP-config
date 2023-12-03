resource "google_compute_instance" "k8s-master" {
  name         = "k8s-master"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "n2d-highmem-2" # 2cpu 16GB
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }
  
  network_interface {
    network =  var.vpc
    subnetwork =  var.subnet
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
  }

}

resource "google_compute_instance" "k8s-node1" {
  name         = "k8s-node1"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "n2d-highmem-4" # 4cpu 32GB
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }
  
  network_interface {
    network =  var.vpc
    subnetwork =  var.subnet
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
  }

}


resource "google_compute_instance" "k8s-node2" {
  name         = "k8s-node2"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "n2d-highmem-4" # 4cpu 32GB
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }
  
  network_interface {
    network =  var.vpc
    subnetwork =  var.subnet
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
  }

}