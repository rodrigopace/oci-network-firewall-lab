#
# Variables for OCI Provider
#
variable "tenancy_ocid" {
  description = "The Tenancy OCID where the instances will be launched"
  type = string
}

variable "user_ocid" {
  description = "The user OCID"
  type = string
}

variable "fingerprint" {
  description = "The fingerprint of the user's key"
  type = string
}

variable "user_private_key_path" {
  description = "The OCI user private key's fingerprint"
  type = string
}

variable "oci_region" {
  description = "The region where the instances will be launched."
  type = string
}

variable "compartment_id" {
  description = "The compartment ID where the instances will be launched."
  type = string
}

variable "drg_name" {
  description = "The compartment ID where the instances will be launched."
  type = string
}

variable "network_firewall_name" {
  description = "OCI Network Firewall Name"
  type = string
}

#
# Variables used in the creation of the compute instances
#
#
variable "availability_domain" {
  description = "The availability domain where the instances will be launched."
  type = string
}
#
variable "image_source_ocid" {
  description = "The OCID of Oracle Linux."
  type = string
}
variable "public_key_path" {
  description = "The path to the public file key"
  type = string
}
