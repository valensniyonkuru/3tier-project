output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.three_tier_asg.name
}

output "launch_template_id" {
  description = "The ID of the Launch Template"
  value       = aws_launch_template.three_tier_lt.id
}
