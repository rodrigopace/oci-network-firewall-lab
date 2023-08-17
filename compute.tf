##################################################
# Compute Instances - Web Servers                #
##################################################

# 
# Instance 01 - App1
#
#     Region: sa-saopaulo-1 (GRU)
#     Image: Oracle Linux 9.x
#     VCN: vcn_private
#     Subnet: subnet_app01
#
resource "oci_core_instance" "srv1_app1" {
  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "[APP1] - Web Instance 01"
  shape               = "VM.Standard.E2.1" # 1 OCPU / 8GB Memory

  source_details {
    source_id         = var.image_source_ocid
    source_type       = "image"
  }
  
  create_vnic_details {
    subnet_id         = oci_core_subnet.subnet_private_app1.id
    assign_public_ip  = false
  }


  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = "${base64encode(file("vm.cloud-config"))}"
  }

  agent_config {

    plugins_config {
      desired_state = "ENABLED"
      name = "Bastion"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    #Optional
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = false
  }

}

resource "oci_core_instance" "srv2_app1" {
  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "[APP1] - Web Instance 02"
  shape               = "VM.Standard.E2.1" # 1 OCPU / 8GB Memory

  source_details {
    source_id         = var.image_source_ocid
    source_type       = "image"
  }
  
  create_vnic_details {
    subnet_id         = oci_core_subnet.subnet_private_app1.id
    assign_public_ip  = false
  }


  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = "${base64encode(file("vm.cloud-config"))}"
  }

  agent_config {

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    #Optional
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = false
  }
}


# 
# Instance 01 - App2
#
#     Region: sa-saopaulo-1 (GRU)
#     Image: Oracle Linux 9.x
#     VCN: vcn_private
#     Subnet: subnet_app01
#
resource "oci_core_instance" "srv1_app2" {
  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "[APP2] - Web Instance 01"
  shape               = "VM.Standard.E2.1" # 1 OCPU / 8GB Memory

  source_details {
    source_id         = var.image_source_ocid
    source_type       = "image"
  }
  
  create_vnic_details {
    subnet_id         = oci_core_subnet.subnet_private_app2.id
    assign_public_ip  = false
  }


  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = "${base64encode(file("vm.cloud-config"))}"
  }

  agent_config {

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    #Optional
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
  }

}

resource "oci_core_instance" "srv2_app2" {
  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "[APP2] - Web Instance 02"
  shape               = "VM.Standard.E2.1" # 1 OCPU / 8GB Memory

  source_details {
    source_id         = var.image_source_ocid
    source_type       = "image"
  }
  
  create_vnic_details {
    subnet_id         = oci_core_subnet.subnet_private_app2.id
    assign_public_ip  = false
  }


  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data           = "${base64encode(file("vm.cloud-config"))}"
  }

  agent_config {

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    #Optional
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
  }
}