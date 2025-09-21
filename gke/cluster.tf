variable "cluster_name"{
    type        = string
    description = "cluster name"
    default     = "my-cluster1"
}

resource "google_container_cluster" "my-cluster1" {
  count =1 
  name     = var.cluster_name
  location = var.region_id

  # use custom node pool but not default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  # Gke master will has his own managed vpc
  #but gke will create nodes and svcs under below vpc and subnet
  # they will use vpc peering to connect each other
  network =  var.vpc0
  subnetwork =  var.vpc0_subnet2

  ip_allocation_policy {
    # tell where pods could get the ip
    cluster_secondary_range_name = "pods-range" # need pre-defined in tf-vpc0-SUbnet0

    #tell where svcs could get the ip
    services_secondary_range_name = "services-range" 
  }


   master_authorized_networks_config {
    #enabled = true
    #gcp_public_cidrs_access_enabled = true
    private_endpoint_enforcement_enabled = false
     # 第一个IP范围
 

  }

  private_cluster_config {
    enable_private_nodes    = true #  nodes do not have public ip
    enable_private_endpoint = true # master do not have public ip
    # set the ip range of master node
    # as mentioned above, master will has his own vpc network
    # so we could not define the ip range which is used in tf-vpc0
    master_ipv4_cidr_block = "192.168.4.96/28" #192.168.3.96 - 192.168.3.111
      # 允许从公共网络访问私有控制平面端点（仍然需要认证授权）

    #private_endpoint_enforcement_enabled = false
    master_global_access_config {
      enabled = true
    }

    }

  
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
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "my-node-pool1" {
    count =1
    name ="my-node-pool1"
    #│ Because google_container_cluster.my-cluster1 has "count" set, its attributes must be accessed on
  # specific instances.
    cluster = google_container_cluster.my-cluster1[0].name
    location = google_container_cluster.my-cluster1[0].location

    #The number of nodes per instance group. This field can be used to update the number of nodes per instance group but should not be used alongsid
    node_count =2
 
    node_config {
      machine_type = "n2d-highmem-4"
      image_type = "COS_CONTAINERD"
      #grants the nodes in "my-node-pool1" full access to all Google Cloud Platform services.
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"] 
      service_account  = "vm-common@jason-hsbc.iam.gserviceaccount.com"
     
    }
}