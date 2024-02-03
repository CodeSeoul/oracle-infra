variable "region" {
  type    = string
  default = "ap-chuncheon-1"
}

variable "compartment_id" {
  type    = string
  default = "ocid1.compartment.oc1..aaaaaaaad3euiylbm5te2snpodedi32xcljemiwsdu5roteybon4ec4rksxq"
}

variable "kubernetes_version" {
  type    = string
  default = "v1.28.2"
}

variable "network_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "node_count" {
  type    = number
  default = 4
}

variable "cpu_count_per_node" {
  type    = number
  default = 1
}

variable "memory_per_node" {
  type    = number
  default = 6
}

variable "node_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "boot_volume_size" {
  type    = number
  default = 50
}

variable "ad_index" {
  type    = number
  default = 0
}

variable "node_eviction_grace_duration" {
  type    = string
  default = "PT60M" # Format ISO 8601
}

variable "node_image_id" {
  # the oci_core_images data source sucks and doesn't
  # have filtering for Kubernetes-compatible images
  type = string
  # Oracle-Linux-8.8-aarch64-2023.12.13-0-OKE-1.28.2-668
  default = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaadhv7y6r5gggfnyqejx3d4l4bwturz4nlvaqa342hvbgsiwmat3vq"
}
