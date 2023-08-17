##################################################
# Network Firewall                               #
##################################################
   

resource "oci_network_firewall_network_firewall" "lab_network_firewall" {
    compartment_id             = var.compartment_id
    network_firewall_policy_id = oci_network_firewall_network_firewall_policy.allow_all_http_policy.id
    subnet_id                  = oci_core_subnet.subnet_nfw.id
    display_name               = var.network_firewall_name
}

data "oci_core_private_ips" "nfw_private_ip" {
  subnet_id  = oci_core_subnet.subnet_nfw.id

  depends_on = [
    oci_network_firewall_network_firewall.lab_network_firewall
  ]
}