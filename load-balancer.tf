### Network Load Balancer
resource "yandex_lb_target_group" "lamp_target_group" {
  name      = "lamp-target-group"
  folder_id = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp_group.instances

    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lamp_balancer" {
  name      = "lamp-load-balancer"
  folder_id = var.folder_id

  listener {
    name = "http-listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp_target_group.id

    healthcheck {
      name                = "http-check"
      interval            = 20
      timeout             = 10
      unhealthy_threshold = 3
      healthy_threshold   = 2

      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}