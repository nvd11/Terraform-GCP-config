resource "google_compute_instance" "my_vm" {
  name         = "my-vm"
  project  = var.project_id
  region = var.region_id
  

  machine_type = "n2d-highmen-2"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }
  
  availability_policy {
    preemptible = true
  }

  network_interface {
    network = "default"
    subnetwork = "subnet-west2"
  }

  service_account {
    email  = "vm-common@jason-hsbc.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}