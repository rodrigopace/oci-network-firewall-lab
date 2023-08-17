##################################
# Creating Logging
##################################

# Creating Log Group
resource "oci_logging_log_group" "nfw_lab_loggroup" {
  compartment_id = var.compartment_id
  
  description    = "The log group for OCI Network Firewall Lab"
  display_name   = "NFW_Lab_LogGroup"
}

# Creating NFW Logging
resource "oci_logging_log" "nfw_inbound_trafficLog" {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "trafficlog"
      resource     = oci_network_firewall_network_firewall.lab_network_firewall.id
      service      = "ocinetworkfirewall"
      source_type  = "OCISERVICE"
    }
  }
  display_name       = "NFW_INBOUND_TrafficLog"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

#
# Creating Loab Balancer Logging for App1
#

# Error Log
resource oci_logging_log lb_app1_error_log {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "error"
      resource     = oci_load_balancer_load_balancer.lb_app1.id
      service      = "loadbalancer"
      source_type  = "OCISERVICE"
    }
  }
  
  display_name       = "lb_app1_error_log"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

# Access Log
resource oci_logging_log lb_app1_access_log {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "access"
      resource     = oci_load_balancer_load_balancer.lb_app1.id
      service      = "loadbalancer"
      source_type  = "OCISERVICE"
    }
  }
  
  display_name       = "lb_app1_access_log"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

#
# Creating Loab Balancer Logging for App2
#

# Error Log
resource oci_logging_log lb_app2_error_log {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "error"
      resource     = oci_load_balancer_load_balancer.lb_app2.id
      service      = "loadbalancer"
      source_type  = "OCISERVICE"
    }
  }
  
  display_name       = "lb_app2_error_log"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

# Access Log
resource oci_logging_log lb_app2_access_log {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "access"
      resource     = oci_load_balancer_load_balancer.lb_app2.id
      service      = "loadbalancer"
      source_type  = "OCISERVICE"
    }
  }
  
  display_name       = "lb_app2_access_log"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

#
# Creating VCN Flow Logs for subnet_nfw
#

# subnet_nfw Logs
resource oci_logging_log subnet_nfw_logs {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "all"
      resource     = oci_core_subnet.subnet_nfw.id
      service      = "flowlogs"
      source_type  = "OCISERVICE"
    }
  }

  display_name       = "subnet_nfw_logs"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

# subnet_lb Logs
resource oci_logging_log subnet_lb_logs {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "all"
      resource     = oci_core_subnet.subnet_lb.id
      service      = "flowlogs"
      source_type  = "OCISERVICE"
    }
  }

  display_name       = "subnet_lb_logs"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

# subnet_private_app1 Logs
resource oci_logging_log subnet_private_app1_logs {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "all"
      resource     = oci_core_subnet.subnet_private_app1.id
      service      = "flowlogs"
      source_type  = "OCISERVICE"
    }
  }

  display_name       = "subnet_private_app1_logs"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

# subnet_private_app2 Logs
resource oci_logging_log subnet_private_app2_logs {
  configuration {
    compartment_id = var.compartment_id
    source {
      category     = "all"
      resource     = oci_core_subnet.subnet_private_app2.id
      service      = "flowlogs"
      source_type  = "OCISERVICE"
    }
  }

  display_name       = "subnet_private_app2_logs"
  is_enabled         = "true"
  log_group_id       = oci_logging_log_group.nfw_lab_loggroup.id
  log_type           = "SERVICE"
  retention_duration = "30"
}

