terraform {
    required_providers {
      oci = {
        source = "oracle/oci"
      }
    }

    backend "s3" {
        bucket   = "codeseoul-terraform-states"
        key      = "oracle-infra.tfstate"
        region   = "ap-chuncheon-1"
        profile  = "oracle-default"
        endpoints = {
            s3  = "https://axgc9l7ssm9n.compat.objectstorage.ap-chuncheon-1.oraclecloud.com"
        }
        skip_region_validation      = true
        skip_credentials_validation = true
        skip_metadata_api_check     = true
        use_path_style              = true
        skip_requesting_account_id  = true
        skip_s3_checksum            = true
  }
}

provider "oci" {
    auth   = "InstancePrincipal"
    region = var.region
}