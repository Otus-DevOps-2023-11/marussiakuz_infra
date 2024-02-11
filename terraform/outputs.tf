output "instance_ips" {
  value = [for i in yandex_compute_instance.app : i.network_interface.0.nat_ip_address]
}

output "lb_external_ip" {
  value = yandex_alb_load_balancer.reddit_lb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
