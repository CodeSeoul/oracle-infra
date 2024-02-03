module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.6.0"

  compartment_id               = var.compartment_id
  region                       = var.region
  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null

  vcn_name      = "main"
  vcn_dns_label = "main"
  vcn_cidrs     = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}

resource "oci_core_subnet" "service_lb_subnet" {
  cidr_block                 = "10.0.20.0/24"
  compartment_id             = var.compartment_id
  display_name               = "loadbalancer-subnet"
  dns_label                  = "loadbalancer"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = module.vcn.ig_route_id
  security_list_ids          = [oci_core_security_list.service_lb.id]
  vcn_id                     = module.vcn.vcn_id
}

resource "oci_core_subnet" "node_subnet" {
  cidr_block                 = "10.0.10.0/24"
  compartment_id             = var.compartment_id
  display_name               = "k8s-node-subnet"
  dns_label                  = "k8snode"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = module.vcn.nat_route_id
  security_list_ids          = [oci_core_security_list.node.id]
  vcn_id                     = module.vcn.vcn_id
}

resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
  cidr_block                 = "10.0.0.0/28"
  compartment_id             = var.compartment_id
  display_name               = "k8s-api-subnet"
  dns_label                  = "k8sapi"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = module.vcn.ig_route_id
  security_list_ids          = [oci_core_security_list.kubernetes_api.id]
  vcn_id                     = module.vcn.vcn_id
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.compartment_id
}
