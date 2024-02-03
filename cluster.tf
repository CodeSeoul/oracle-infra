resource "oci_containerengine_cluster" "main" {
  compartment_id = var.compartment_id
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id            = oci_core_subnet.kubernetes_api_endpoint_subnet.id
  }
  freeform_tags = {
    "OKEclusterName" = "main"
  }
  kubernetes_version = var.kubernetes_version
  name               = "main"
  options {
    admission_controller_options {
      is_pod_security_policy_enabled = "false"
    }
    persistent_volume_config {
      freeform_tags = {
        "OKEclusterName" = "main"
      }
    }
    service_lb_config {
      freeform_tags = {
        "OKEclusterName" = "main"
      }
    }
    service_lb_subnet_ids = [oci_core_subnet.service_lb_subnet.id]
  }
  vcn_id = module.vcn.vcn_id
}

resource "oci_containerengine_node_pool" "main_node_pool" {
  cluster_id     = oci_containerengine_cluster.main.id
  compartment_id = var.compartment_id
  freeform_tags = {
    "OKEnodePoolName" = "main"
  }
  initial_node_labels {
    key   = "name"
    value = "main"
  }
  kubernetes_version = var.kubernetes_version
  name               = "main"
  node_config_details {
    freeform_tags = {
      "OKEnodePoolName" = "main"
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.ad_index].name
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    size = var.node_count
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration = var.node_eviction_grace_duration
  }
  node_shape = var.node_shape
  node_shape_config {
    memory_in_gbs = var.memory_per_node
    ocpus         = var.cpu_count_per_node
  }
  node_source_details {
    image_id                = var.node_image_id
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = var.boot_volume_size
  }
}

data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {
  cluster_id    = oci_containerengine_cluster.main.id
  token_version = "2.0.0"
}

# https://www.terraform.io/docs/providers/local/r/file.html
resource "local_file" "kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.cluster_kube_config.content
  filename = "${path.module}/kubeconfig"
}
