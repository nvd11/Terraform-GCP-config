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


# this vm is under tf-vpc0 subnet 0, for vpc connectivity testing
resource "google_compute_instance" "tf-vpc0-subnet0-vm0" {
  name         = "tf-vpc0-subnet0-vm0"
  project  = var.project_id
  zone = var.zone_id
  
  allow_stopping_for_update = true
  machine_type = "e2-small" # 0.5-2 vCPU (1 shared core) , 2GB Mem
  
  boot_disk {
    auto_delete = false # as there's an instance image created based on this disk
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

# this vm is under tf-vpc0 subnet 0, for vpc connectivity testing
resource "google_compute_instance" "tf-vpc0-subnet0-vm1" {
  name         = "tf-vpc0-subnet0-vm1"
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


# this vm is under tf-vpc0 subnet 1, for vpc connectivity testing
resource "google_compute_instance" "tf-vpc0-subnet1-vm0" {
  name         = "tf-vpc0-subnet1-vm0"
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
    network =  var.vpc0
    subnetwork =  var.vpc0_subnet1
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




# this vm is under tf-vpc1 subnet 0, and tf-vpc0 subnet0  , dual ips , for vpc nat-getaway ip forwarding testing
resource "google_compute_instance" "tf-vpc0-subnet0-vpc1-subnet0-vm0" {
  name         = "tf-vpc0-subnet0-vpc1-subnet0-vm0"
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
    network =  var.vpc0
    subnetwork =  var.vpc0_subnet0
    
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

  can_ip_forward = true

}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template
# this vm is created based on an instance template
resource "google_compute_instance_from_template" "tf-vpc1-subnet0-vm20" {
  name         = "tf-vpc1-subnet0-vm20"
  project      = var.project_id
  zone         = var.zone_id
  allow_stopping_for_update = true

  # from a instance template
  source_instance_template = "https://www.googleapis.com/compute/v1/projects/jason-hsbc/global/instanceTemplates/e2-small-tomcat"
}