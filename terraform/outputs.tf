output "alb_url" {
  description = "Public URL of the application load balancer."
  value       = module.application.alb_url
}

output "vpc_id" {
  value = module.network.vpc_id
}
