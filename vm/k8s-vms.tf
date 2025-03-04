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
    network =  var.vpc0
    subnetwork =  var.vpc0_subnet0
    access_config {
      nat_ip = ""
    }
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



  # to ignore external ip address changes
  lifecycle {
    ignore_changes = [
      network_interface[0].access_config[0].nat_ip,
      network_interface[0].access_config[0].network_tier,
    ]
  }

}

resource "google_compute_instance" "k8s-node0" {
  name         = "k8s-node0"
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

resource "google_compute_instance_from_template" "k8s-node1" {
  name         = "k8s-node1"
  project      = var.project_id
  zone         = var.zone_id
  allow_stopping_for_update = true

  # from a instance template
  source_instance_template = "https://www.googleapis.com/compute/v1/projects/jason-hsbc/global/instanceTemplates/vm-template-k8s-nodes"
}


resource "google_compute_instance_from_template" "k8s-node2" {
  name         = "k8s-node2"
  project      = var.project_id
  zone         = var.zone_id
  allow_stopping_for_update = true

  # from a instance template
  source_instance_template = "https://www.googleapis.com/compute/v1/projects/jason-hsbc/global/instanceTemplates/vm-template-k8s-nodes"
}


resource "google_compute_instance_from_template" "k8s-node3" {
  name         = "k8s-node3"
  project      = var.project_id
  zone         = var.zone_id
  allow_stopping_for_update = true

  # from a instance template
  source_instance_template = "https://www.googleapis.com/compute/v1/projects/jason-hsbc/global/instanceTemplates/vm-template-k8s-nodes"
}