output "nat_instance_public_ip" {
  description = "Public IP NAT"
  value       = yandex_compute_instance.nat_instance.network_interface[0].nat_ip_address
}

# output "public_vm_public_ip" {
#   description = "Public IP public VM"
#   value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
# }

# output "public_vm_private_ip" {
#   description = "Internal IP public VM"
#   value       = yandex_compute_instance.public_vm.network_interface[0].ip_address
# }

# output "private_vm_private_ip" {
#   description = "Internal IP private VM"
#   value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
# }

### Storage outputs =============================================================
output "bucket_name" {
  description = "Name of created bucket"
  value       = yandex_storage_bucket.netology_bucket.bucket
}

output "picture_url" {
  description = "Public URL of uploaded picture"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.netology_bucket.bucket}/${yandex_storage_object.picture.key}"
}

### Instance Group outputs ======================================================
output "instance_group_id" {
  description = "ID of created Instance Group"
  value       = yandex_compute_instance_group.lamp_group.id
}

output "instance_ips" {
  description = "Public IPs of instances in group"
  value       = yandex_compute_instance_group.lamp_group.instances[*].network_interface[0].nat_ip_address
}

### Load Balancer outputs =======================================================
### Load Balancer outputs =======================================================
output "load_balancer_ip" {
  description = "Public IP address of Network Load Balancer"
  value = one([
    for listener in yandex_lb_network_load_balancer.lamp_balancer.listener :
    one([for addr in listener.external_address_spec : addr.address])
  ])
}