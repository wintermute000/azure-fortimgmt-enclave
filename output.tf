output "ResourceGroup" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "FortiGatePublicIP" {
  value = format("https://%s:%s", azurerm_public_ip.PublicIP.ip_address, var.adminsport)
}

output "FortiManagerPublicIP" {
  value = format("https://%s:%s", azurerm_public_ip.PublicIP.ip_address, var.fmgadminsport)
}

output "FortiAnalyzerPublicIP" {
  value = format("https://%s:%s", azurerm_public_ip.PublicIP.ip_address, var.fazadminsport)
}

output "VNET_CIDR" {
  value = var.vnetcidr
}

output "FgtUsername" {
  value = var.adminusername
}

output "FgtPassword" {
  value = var.adminpassword
}

output "FMGFAZUsername" {
  value = var.fmgfazadminusername
}

output "FMGFAZPassword" {
  value = var.fmgfazadminpassword
}

