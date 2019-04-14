module "provider" {
  source = "../../azure/provider"
}

resource "azurerm_resource_group" "common_rg" {
  name     = "${var.common_infra_resource_group}"
  location = "${var.common_infra_resource_group_location}"
}

resource "azurerm_resource_group" "user_rg" {
  count    = "${var.number_of_users}"
  name     = "${var.user_resource_group_base}-${count.index}"
  location = "${azurerm_resource_group.common_rg.location}"
}

resource "random_uuid" "users" {
  count    = "${var.number_of_users}"
}

resource "random_uuid" "passwords" {
  count    = "${var.number_of_users}"
}

resource "azuread_application" "users" {
  count    = "${var.number_of_users}"
  name     = "${random_uuid.users.*.result[count.index]}"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false

  depends_on = ["azurerm_resource_group.user_rg"]
}

resource "azuread_service_principal" "users" {
  count    = "${var.number_of_users}"
  application_id = "${azuread_application.users.*.application_id[count.index]}"
}

resource "azuread_service_principal_password" "users" {
  count    = "${var.number_of_users}"
  service_principal_id = "${azuread_service_principal.users.*.id[count.index]}"
  value                = "${random_uuid.passwords.*.result[count.index]}"
  end_date_relative    = "${var.end_date_relative}"
}

resource "azurerm_role_assignment" "user_rg" {
  count    = "${var.number_of_users}"
  scope                = "${azurerm_resource_group.user_rg.*.id[count.index]}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal.users.*.id[count.index]}"
}

resource "azurerm_role_assignment" "common_rg_netowrk" {
  count    = "${var.number_of_users}"
  scope                = "${azurerm_resource_group.user_rg.*.id[count.index]}"
  role_definition_name = "Network Contributor"
  principal_id         = "${azuread_service_principal.users.*.id[count.index]}"
}

resource "azurerm_role_assignment" "common_rg_keyvault" {
  count    = "${var.number_of_users}"
  scope                = "${azurerm_resource_group.common_rg.id}"
  role_definition_name = "Key Vault Contributor"
  principal_id         = "${azuread_service_principal.users.*.id[count.index]}"
}

output "user_ids" {
  value = ["${azuread_application.users.*.application_id}"]
}

output "user_passwords" {
  value = ["${random_uuid.passwords.*.result}"]
  sensitive = true
}
