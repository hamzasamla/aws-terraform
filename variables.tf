variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0dc3a08bd93f84a35" # Amazon Linux 2 
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "testkey"
  description = "Name of the SSH key pair to use for the instance."
}

# variable "vpc_id" {
#     description = "The ID of the VPC where resources will be created."
#     type        = string
# }
# variable "public_subnet_ids" {
#   type = list(string)
# }

# RDS Credentials
variable "db_username" {
  description = "Master username for RDS instances"
  type        = string
  default     = "hamzasamla"
}

variable "db_password" {
  description = "Master password for RDS instances"
  type        = string
  default     = "Abc75000"
}

variable "db_allocated_storage" {
  description = "Storage (GB) for each RDS instance"
  type        = number
  default     = 5
}

variable "rds_engine_version_mysql" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.41"
}

variable "rds_engine_version_postgres" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.4"
}
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to use for HTTPS"
  type        = string
  default = "arn:aws:acm:us-east-1:323869527304:certificate/dbefca87-2339-4f7a-af2e-b2d1cd2a83cd"
}