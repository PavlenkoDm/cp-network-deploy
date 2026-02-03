###Network
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

###NAT
resource "yandex_compute_instance" "nat_instance" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.nat_instance_ip
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

###Public VM
resource "yandex_compute_instance" "public_vm" {
  name        = var.public_vm_name
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

### Data source
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

### ============================================================
### Route Table
resource "yandex_vpc_route_table" "private_route" {
  name       = "private-route"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip
  }
}

### Private subnet
resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private_route.id
}

### Private VM
resource "yandex_compute_instance" "private_vm" {
  name        = var.private_vm_name
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
