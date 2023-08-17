##################################################
# Load Balancers                                 #
##################################################

#
# LB 01 - App1
#
#     Region: sa-saopaulo-1 (GRU)
#     VCN: vcn_public
#     Subnet: subnet_loadbalancer
#

# Creating Load Balancer for Website/App1
resource "oci_load_balancer_load_balancer" "lb_app1" {
    #Required
    compartment_id  = var.compartment_id
    display_name    = "LoadBalancer_App1"
    shape           = "flexible"
    subnet_ids      = [oci_core_subnet.subnet_lb.id]

    #Optional
    ip_mode     = "IPV4"
    is_private  = false

    shape_details {
        #Required
        maximum_bandwidth_in_mbps = 10
        minimum_bandwidth_in_mbps = 10
    }
}

# Create Backendset for lb_app1
resource "oci_load_balancer_backend_set" "app1_backend_set" {
    #Required
    health_checker {
        #Required
        protocol = "HTTP"

        #Optional
        retries     = 3
        url_path    = "/"
    }
    load_balancer_id    = oci_load_balancer_load_balancer.lb_app1.id
    name                = "app1_backend_set"
    policy              = "ROUND_ROBIN"
}

# Creating HTTP Listener for lb_app1
resource "oci_load_balancer_listener" "lb_app1_listerner" {
    #Required
    default_backend_set_name = oci_load_balancer_backend_set.app1_backend_set.name
    load_balancer_id         = oci_load_balancer_load_balancer.lb_app1.id
    name                     = "lb_app1_listerner"
    port                     = 80
    protocol                 = "HTTP"
}

# Creating the backent to host the Web/App servers
resource "oci_load_balancer_backend" "srv1_app1_backend" {
    #Required
    backendset_name  = oci_load_balancer_backend_set.app1_backend_set.name
    ip_address       = oci_core_instance.srv1_app1[0].private_ip
    load_balancer_id = oci_load_balancer_load_balancer.lb_app1.id
    port             = 80
}

resource "oci_load_balancer_backend" "srv2_app1_backend" {
    #Required
    backendset_name  = oci_load_balancer_backend_set.app1_backend_set.name
    ip_address       = oci_core_instance.srv2_app1[0].private_ip
    load_balancer_id = oci_load_balancer_load_balancer.lb_app1.id
    port             = 80
}

#
# LB 02 - App2
#
#     Region: sa-saopaulo-1 (GRU)
#     VCN: vcn_public
#     Subnet: subnet_loadbalancer
#

# Creating Load Balancer for Website/App2
resource "oci_load_balancer_load_balancer" "lb_app2" {
    #Required
    compartment_id = var.compartment_id
    display_name   = "LoadBalancer_App2"
    shape          = "flexible"
    subnet_ids     = [oci_core_subnet.subnet_lb.id]

    #Optional
    ip_mode     = "IPV4"
    is_private  = false

    shape_details {
        #Required
        maximum_bandwidth_in_mbps = 10
        minimum_bandwidth_in_mbps = 10
    }
}

# Create Backendset for lb_app1
resource "oci_load_balancer_backend_set" "app2_backend_set" {
    #Required
    health_checker {
        #Required
        protocol = "HTTP"

        #Optional
        retries  = 3
        url_path = "/"
    }
    load_balancer_id = oci_load_balancer_load_balancer.lb_app2.id
    name   = "app2_backend_set"
    policy = "ROUND_ROBIN"
}

# Creating HTTP Listener for lb_app1
resource "oci_load_balancer_listener" "lb_app2_listerner" {
    #Required
    default_backend_set_name = oci_load_balancer_backend_set.app2_backend_set.name
    load_balancer_id         = oci_load_balancer_load_balancer.lb_app2.id
    name                     = "lb_app2_listerner"
    port                     = 80
    protocol                 = "HTTP"
}

# Creating the backent to host the Web/App servers
resource "oci_load_balancer_backend" "srv1_app2_backend" {
    #Required
    backendset_name  = oci_load_balancer_backend_set.app2_backend_set.name
    ip_address       = oci_core_instance.srv1_app2[0].private_ip
    load_balancer_id = oci_load_balancer_load_balancer.lb_app2.id
    port             = 80
}

resource "oci_load_balancer_backend" "srv2_app2_backend" {
    #Required
    backendset_name  = oci_load_balancer_backend_set.app2_backend_set.name
    ip_address       = oci_core_instance.srv2_app2[0].private_ip
    load_balancer_id = oci_load_balancer_load_balancer.lb_app2.id
    port             = 80
}