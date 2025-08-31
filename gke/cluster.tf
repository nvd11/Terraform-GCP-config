variable "cluster_name"{
    type        = string
    description = "cluster name"
    default     = "my-cluster1"
}

resource "google_container_cluster" "my-cluster1" {
  name     = var.cluster_name
  location = var.region_id

  # use custom node pool but not default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
 
  network =  var.vpc0
  subnetwork =  var.vpc0_subnet0
  
  # configuration of fleet(GKEHUB)， the key part
  # fleet membership name
  # format usually be projects/{project_id}/locations/global/memberships/{membership_id}
  # we create it dymanic here, to use cluster namd as membership name
  # we could get the memberships info by gcloud command:
  # gcloud contianer fleet memberships list
  fleet {
    #Can't configure a value for "fleet.0.membership": its value will be decided automatically based on the result of applying this configuration.
    #membership = "projects/${var.project_id}/locations/global/memberships/${var.cluster_name}"
    project = var.project_id
  }
}
  # create a node pool
  
resource "google_container_node_pool" "my-node-pool1" {
    name ="my-node-pool1"
    cluster = google_container_cluster.my-cluster1.name
    location = google_container_cluster.my-cluster1.location
    # the node_count in the google_container_node_pool resource specifies the number of virtual machines (nodes) that will be created and managed within that node pool
    node_count =3
 
    node_config {
      machine_type = "n2d-highmem-4"
  
      #grants the nodes in "my-node-pool1" full access to all Google Cloud Platform services.
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"] 
      service_account  = "vm-common@jason-hsbc.iam.gserviceaccount.com"
     
    }
}