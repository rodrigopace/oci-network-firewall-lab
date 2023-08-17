# Printing the Load Balancer's public IPs
output "public_ip_app1"{
    description = "App1 Public IP"
    value       = oci_load_balancer_load_balancer.lb_app1.ip_address_details[0].ip_address
}

output "public_ip_app2"{
    description = "App2 Public IP"
    value       = oci_load_balancer_load_balancer.lb_app2.ip_address_details[0].ip_address
}
