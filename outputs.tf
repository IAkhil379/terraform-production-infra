output "alb_dns_name" {
  description = "The public entry point to access the web application"
  value       = "http://${aws_lb.prod_alb.dns_name}"
}
