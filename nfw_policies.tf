##################################################
# Network Firewall Policies                      #
##################################################

# Creating OCI Network Firewall Policy
resource "oci_network_firewall_network_firewall_policy" "allow_all_http_policy" {
    #Required
    compartment_id = var.compartment_id
    display_name   = "NFW_Allow_All_80"

    #Optional
    application_lists {
        #Required
      application_list_name = "HTTP"
        application_values {
          type              = "TCP"
          #Optional
          minimum_port      = 80
          maximum_port      = 80
        }
    }
    
    ip_address_lists {
        ip_address_list_name  = "Any"
        ip_address_list_value = ["0.0.0.0/0"]
    }
    
    ip_address_lists {
        ip_address_list_name  = "LB_NETWORK_PRIVATE_CIDR"
        ip_address_list_value = [oci_core_subnet.subnet_lb.cidr_block]
    }

    security_rules {
        #Required
        action           = "ALLOW"
        condition {
            #Optional
            applications = ["HTTP"]
            destinations = ["LB_NETWORK_PRIVATE_CIDR"]
            sources      = ["Any"]
        }
        name             = "allow_all_http"
    }
}
