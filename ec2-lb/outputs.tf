
output "alb_dns_name" {
  value       = aws_lb.spixrnc-lb.dns_name
  description = "value of the DNS name of the application load balancer"
}
