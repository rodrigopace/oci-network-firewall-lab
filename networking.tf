##################################
# Creating Public VCN
##################################

# Creating VCN
resource "oci_core_vcn" "vcn_public" {

  # The module always use the new list of string structure and let the customer update his module definition block at his own pace.
  cidr_blocks    = ["10.0.0.0/23"]
  compartment_id = var.compartment_id
  display_name   = "vcn_public"
  dns_label      = "vcnpublic"
}

# Creating Subnet NFW
resource "oci_core_subnet" "subnet_nfw" {
    # Required
    cidr_block     = "10.0.0.0/24"
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    # Optional
    display_name      = "subnet_nfw"
    dns_label         = "subnetnfw"
    security_list_ids = [oci_core_security_list.security_list_allow_http.id]
}


# Creating Subnet LB
resource "oci_core_subnet" "subnet_lb" {
    # Required
    cidr_block     = "10.0.1.0/24"
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    # Optional
    display_name      = "subnet_lb"
    dns_label         = "subnetlb"
    security_list_ids = [oci_core_security_list.security_list_allow_http.id]
}

# Creating Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id
    route_table_id = oci_core_route_table.RT_to_nfw.id
    #Optional
    display_name   = "internet_gateway"
}

# Creating routing table RT_NFW in the Public VCN
resource "oci_core_route_table" "RT_NFW" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    #Optional
    display_name   = "RT_NFW"
    
    route_rules {
        network_entity_id = oci_core_internet_gateway.internet_gateway.id
        description       = "Default route to Internet Gateway"
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
    }

     route_rules {
         network_entity_id = data.oci_core_private_ips.nfw_private_ip.private_ips[0].id
         description       = "Route to LB subnet must go through OCI Network Firewall"
         destination       = "10.0.1.0/24"
         destination_type  = "CIDR_BLOCK"
     }
}

# Creating routing table RT_NFW in the Public VCN
resource "oci_core_route_table" "RT_LB" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    #Optional
    display_name   = "RT_LB"
     route_rules {
         network_entity_id = oci_core_drg.lab_drg.id
         description       = "Route to 192.168.0.0/24 goes through DRG Attachment"
         destination       = "192.168.0.0/24"
         destination_type  = "CIDR_BLOCK"
     }

    route_rules {
        network_entity_id = oci_core_drg.lab_drg.id
        description       = "Route to 0.0.0.0/0 goes through OCI Network Firewall"
        destination       = "192.168.1.0/24"
        destination_type  = "CIDR_BLOCK"
    }

    route_rules {
        network_entity_id = data.oci_core_private_ips.nfw_private_ip.private_ips[0].id
        description       = "Default route to Network Firewall"
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
    }
}

# Creating routing table RT_to_nfw in the Public VCN to attach in the Internet Gateway
resource "oci_core_route_table" "RT_to_nfw" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    #Optional
    display_name   = "RT_to_nfw"
     route_rules {
         network_entity_id = data.oci_core_private_ips.nfw_private_ip.private_ips[0].id
         description       = "Route all to OCI Network Firewall"
         destination       = "10.0.1.0/24"
         destination_type  = "CIDR_BLOCK"
     }
}


 resource "oci_core_route_table_attachment" "subnet_lb_route_table_attachment" {
   #Required    
   subnet_id      = oci_core_subnet.subnet_lb.id
   route_table_id = oci_core_route_table.RT_LB.id
 }

 resource "oci_core_route_table_attachment" "subnet_nfw_route_table_attachment" {
   #Required    
   subnet_id      = oci_core_subnet.subnet_nfw.id
   route_table_id = oci_core_route_table.RT_NFW.id
 }

resource "oci_core_security_list" "security_list_allow_http" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_public.id

    #Optional
    display_name       = "security_list_allow_http"
    egress_security_rules {
      stateless        = false
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      protocol         = "all" 
    }

    ingress_security_rules { 
      stateless   = false
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      description = "Allow connectivity from Internet to web servers in 80/TCP (passing through OCI Network Firewall)"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol    = "6"
      tcp_options { 
          min = 80
          max = 80
      }
    }
}

resource "oci_core_security_list" "security_list_allow_http_private" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_private.id

    #Optional
    display_name       = "security_list_allow_http"
    egress_security_rules {
      stateless        = false
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      protocol = "all" 
    }

    ingress_security_rules { 
      stateless   = false
      source      = "10.0.1.0/24"
      source_type = "CIDR_BLOCK"
      description = "Allow connectivity from 10.0.1.0/24 (LB subnet) to web servers in 80/TCP"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol    = "6"
      tcp_options { 
          min = 80
          max = 80
      }
    }
    ingress_security_rules { 
      stateless   = false
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      description = "Allow connectivity from 10.0.1.0/24 (LB subnet) to web servers in 80/TCP"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol = "6"
      tcp_options { 
          min = 22
          max = 22
      }
    }
}

##################################
# Creating Private VCN
##################################

# Creating Private VCN
resource "oci_core_vcn" "vcn_private" {

  # The module always use the new list of string structure and let the customer update his module definition block at his own pace.
  cidr_blocks    = ["192.168.0.0/23"]
  compartment_id = var.compartment_id
  display_name   = "vcn_private"
  dns_label      = "vcnprivate"
}

# Creating Subnet App1
resource "oci_core_subnet" "subnet_private_app1" {
    # Required
    cidr_block     = "192.168.0.0/24"
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_private.id

    # Optional
    display_name               = "subnet_web_app1"
    dns_label                  = "subnetwebapp1"
    route_table_id             = oci_core_route_table.RT_PRIVATE.id
    security_list_ids          = [oci_core_security_list.security_list_allow_http_private.id]
    prohibit_public_ip_on_vnic = true
}

# Creating Subnet App2
resource "oci_core_subnet" "subnet_private_app2" {
    # Required
    cidr_block     = "192.168.1.0/24"
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_private.id

    # Optional
    display_name               = "subnet_web_app2"
    dns_label                  = "subnetwebapp2"
    route_table_id             = oci_core_route_table.RT_PRIVATE.id
    security_list_ids          = [oci_core_security_list.security_list_allow_http_private.id]
    prohibit_public_ip_on_vnic = true
}
#####


# Creating Service Gateway for Private Subnet
data "oci_core_services" "service-gateway-services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Creating Service Gateway for Private Subnet
data "oci_core_service_gateways" "Service_Gateway_Data" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  state  = "AVAILABLE"
  vcn_id = oci_core_vcn.vcn_private.id
}

# Creating Service Gateway for Private Subnet
resource "oci_core_service_gateway" "service_gateway" {
    #Required
    compartment_id = var.compartment_id
    display_name   = "Service_Gateway"
    services {
        service_id = data.oci_core_services.service-gateway-services.services[0]["id"]
    }
    vcn_id         = oci_core_vcn.vcn_private.id
}

# Creating RT_PRIVATE route table
resource "oci_core_route_table" "RT_PRIVATE" {
    #Required
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.vcn_private.id

    #Optional
    display_name   = "RT_PRIVATE"
    
    route_rules {
        network_entity_id = oci_core_drg.lab_drg.id
        description      = "Route to LB subnet must go through OCI Network Firewall"
        destination      = "10.0.0.0/23"
        destination_type = "CIDR_BLOCK"
    }

    route_rules {
        destination       = "all-gru-services-in-oracle-services-network"
        destination_type  = "SERVICE_CIDR_BLOCK"
        network_entity_id = oci_core_service_gateway.service_gateway.id
        
  }
}

##################################
# Creating DRG
##################################
resource "oci_core_drg" "lab_drg" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    display_name   = var.drg_name
}

# Creating the DRG public vcn attachment
resource "oci_core_drg_attachment" "attachment_public" {
    #Required
    drg_id       = oci_core_drg.lab_drg.id

    #Optional
    display_name = "att_public"
    
    network_details {
        #Required
        id       = oci_core_vcn.vcn_public.id
        type     = "VCN"
    }
}

# Creating the DRG private vcn attachment
resource "oci_core_drg_attachment" "attachment_private" {
    #Required
    drg_id       = oci_core_drg.lab_drg.id

    #Optional
    display_name = "att_private"
    
    network_details {
        #Required
        id       = oci_core_vcn.vcn_private.id
        type     = "VCN"
    }
}