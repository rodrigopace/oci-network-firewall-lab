# Define the Terraform provider
terraform {
  required_version = ">= 1.3"

  required_providers {
    oci = {
      source    = "hashicorp/oci"
        version = ">= 4.0.0"
      }
    }
}

# Configure the OCI provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = file(var.user_private_key_path)
  region           = var.oci_region
}
