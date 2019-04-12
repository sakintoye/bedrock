module "azure-provider" {
    source = "../provider"
}

resource "azurerm_resource_group" "cluster" {
  count    = "${var.resource_group_preallocated == "1" ? 0 : 1}"
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.cluster_name}"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_preallocated == "0" ? element(concat(azurerm_resource_group.cluster.*.name, list("")), 0) : var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${var.ssh_public_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_vm_count}"
    vm_size         = "${var.agent_vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${var.vnet_subnet_id}"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr = "${var.service_cidr}"
    dns_service_ip = "${var.dns_ip}"
    docker_bridge_cidr = "${var.docker_cidr}"
  }

  role_based_access_control {
    enabled = true
  }

  service_principal {
    client_id     = "${var.service_principal_id}"
    client_secret = "${var.service_principal_secret}"
  }
}
