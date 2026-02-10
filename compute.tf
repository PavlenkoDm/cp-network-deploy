### Instance Group with LAMP

resource "yandex_iam_service_account" "ig_sa" {
  name        = "ig-sa"
  description = "Service account for Instance Group operations"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}

resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig_sa.id

  depends_on = [
    yandex_resourcemanager_folder_iam_member.ig_editor,
    yandex_storage_bucket.netology_bucket
  ]

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = 10
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true

      security_group_ids = [
        yandex_vpc_security_group.allow_all_inbound.id
      ]
    }

    metadata = {
      ssh-keys = "ubuntu:${var.ssh_public_key}"
      user-data = templatefile("${path.module}/cloud-init.yaml", {
        picture_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.netology_bucket.bucket}/${yandex_storage_object.picture.key}"
      })
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 3
    max_expansion   = 1
    max_deleting    = 1
  }

  health_check {
    interval = 30
    timeout  = 10

    healthy_threshold   = 2
    unhealthy_threshold = 2

    http_options {
      port = 80
      path = "/index.html"
    }
  }
}