resource "yandex_alb_target_group" "target-group" {
  name = "reddit-target-group"

  dynamic "target" {
    for_each     = yandex_compute_instance.app
    content {
      subnet_id  = var.subnet_id
      ip_address = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_alb_backend_group" "backend-group" {
  name = "reddit-backend-group"

  http_backend {
    name             = "reddit-http-backend"
    weight           = 1
    port             = 9292
    target_group_ids = ["${yandex_alb_target_group.target-group.id}"]

    load_balancing_config {
      locality_aware_routing_percent = 30
      panic_threshold                = 50
      mode                           = "ROUND_ROBIN"
    }
    healthcheck {
      timeout             = "1s"
      interval            = "1s"
      healthy_threshold   = 1
      unhealthy_threshold = 1
      http_healthcheck {
        path = "/"
      }
    }
    http2 = "false"
  }
}

resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_security_group" "security_group" {
  name        = "reddit security group"
  description = "simple reddit security group"
  network_id  = var.network_id

  ingress {
    protocol          = "TCP"
    description       = "checking the status of the load balancer nodes"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }

  ingress {
    protocol       = "ANY"
    description    = "for external incoming traffic to the handler"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    description    = "to send traffic to the backend VM"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_alb_http_router" "http-router" {
  name      = "reddit-http-router"
  folder_id = var.folder_id
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name           = "reddit-virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "reddit-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "reddit_lb" {
  name = "reddit-load-balancer"

  network_id         = var.network_id
  security_group_ids = ["${yandex_vpc_security_group.security_group.id}"]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = var.subnet_id
    }
  }

  listener {
    name = "reddit-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}
