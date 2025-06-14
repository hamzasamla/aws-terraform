# 3.1 DB Subnet Group (private subnets)
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]
  tags = {
    Name = "main-db-subnet-group"
  }
}

# 3.3 MySQL RDS Instance
resource "aws_db_instance" "mysql" {
  identifier               = "demo-mysql"
  engine                   = "mysql"
  engine_version           = var.rds_engine_version_mysql
  instance_class           = "db.t3.micro"          
  username                 = var.db_username
  password                 = var.db_password
  allocated_storage        = var.db_allocated_storage
  db_subnet_group_name     = aws_db_subnet_group.main.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  skip_final_snapshot      = true
  publicly_accessible      = false
  multi_az                 = false
   db_name = "demoMysql"
  backup_retention_period = 0 # Disable backups for demo purposes
  tags = {
    Name = "demo-mysql"
  }
}

# 3.4 PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier               = "demo-postgres"
  engine                   = "postgres"
  engine_version           = var.rds_engine_version_postgres
  instance_class           = "db.t3.micro"          
  username                 = var.db_username
  password                 = var.db_password
  allocated_storage        = var.db_allocated_storage
  db_subnet_group_name     = aws_db_subnet_group.main.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  skip_final_snapshot      = true
  publicly_accessible      = false
  multi_az                 = false
  db_name = "demoPostgres"
  backup_retention_period = 0 # Disable backups for demo purposes
  tags = {
    Name = "demo-postgres"
  }
}
