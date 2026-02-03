output "nat_instance_public_ip" {
  description = "Public IP NAT"
  value       = yandex_compute_instance.nat_instance.network_interface[0].nat_ip_address
}

output "public_vm_public_ip" {
  description = "Public IP public VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "public_vm_private_ip" {
  description = "Internal IP public VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].ip_address
}

output "private_vm_private_ip" {
  description = "Internal IP private VM"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}