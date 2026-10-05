output "vm_name" {
  value       = module.compute.vm_name
  description = "Navnet på den virtuelle maskinen."
}

output "vm_private_ip" {
  value       = module.compute.private_ip_address
  description = "Maskinens private IP-adresse – ligger i subnettet fra den andre stacken."
}

# Nyttig i innleveringen: viser svart på hvitt hvilken ID som faktisk ble lest
# fra nettverks-stacken.
output "brukt_subnet_id" {
  value       = local.subnet_id
  description = "Subnett-ID-en som ble hentet fra nettverks-stackens outputs."
}