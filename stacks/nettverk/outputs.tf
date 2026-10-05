#stacks/nettverk/outputs.tf

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet-ID per subnettnavn. LESES AV APP-STACKEN – ikke fjern."
}

output "vnet_name" {
  value       = module.network.vnet_name
  description = "Navnet på det virtuelle nettverket. Leses av verifiseringssteget."
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Ressursgruppa stacken eier. Leses av verifiseringssteget."
}

output "subnet_prefixes" {
  value       = module.network.subnet_prefixes
  description = "Utregnet adresseprefiks per subnett. Til feilsøking."
}