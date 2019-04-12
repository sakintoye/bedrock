resource "azurerm_resource_group" "vnet" {
  count    = "${var.resource_group_preallocated == "1" ? 0 : 1}"
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.resource_group_location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${var.resource_group_preallocated == "0" ? element(concat(azurerm_resource_group.vnet.*.name, list("")), 0) : var.resource_group_name}"
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "subnet" {
  name                      = "${var.subnet_names[count.index]}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name = "${var.resource_group_preallocated == "0" ? element(concat(azurerm_resource_group.vnet.*.name, list("")), 0) : var.resource_group_name}"
  address_prefix            = "${var.subnet_prefixes[count.index]}"
  count                     = "${length(var.subnet_names)}"
}