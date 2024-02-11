output "instance_ips" {
  value = [for i in yandex_compute_instance.app : i.network_interface.0.nat_ip_address]
}

output "lb_external_ip" {
  value = element(tolist(yandex_lb_network_load_balancer.reddit-lb.listener),  0).external_address_spec
}
