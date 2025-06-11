output "asg_name" { 
    value = aws_autoscaling_group.app_asg.name 
    }

output "launch_template_id" { 
    value = aws_launch_template.app_template.id 
    }
    
output "mysql_endpoint" {
  description = "MySQL endpoint address"
  value       = aws_db_instance.mysql.address
}

output "postgres_endpoint" {
  description = "PostgreSQL endpoint address"
  value       = aws_db_instance.postgres.address
}
