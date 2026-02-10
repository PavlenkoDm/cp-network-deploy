###cloud vars==========================================
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

### network block ============================================================
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}

variable "public_subnet_name" {
  type        = string
  default     = "public"
  description = "Public subnet name"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "192.168.10.0/24"
  description = "Public subnet CIDR"
}

variable "private_subnet_name" {
  type        = string
  default     = "private"
  description = "Private subnet name"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "192.168.20.0/24"
  description = "Private subnet name CIDR"
}

### VM block ==================================================================
variable "nat_instance_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "Static NAT IP"
}

variable "nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Image ID NAT Yandex Cloud"
}

variable "public_vm_name" {
  type        = string
  default     = "public-vm"
  description = "Public vm name"
}

variable "private_vm_name" {
  type        = string
  default     = "private-vm"
  description = "Private vm name"
}

### Tech block =====================================================================
variable "image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "Public SSH key (type ed25519)"
}

### Storage block ===============================================================
variable "bucket_name" {
  type        = string
  description = "Unique bucket name for Object Storage"
}

variable "picture_path" {
  type        = string
  description = "Path to the picture file on local machine"
}

### Compute block ===============================================================
variable "lamp_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "LAMP image ID from Yandex Cloud"
}







