#!/bin/bash
# Update system
yum update -y

# Install Nginx
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx

# Install Docker
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Git and Node.js
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs git

# Clone repo and run app
cd /home/ec2-user
git clone https://github.com/hamzasamla/devops-sample-app.git
cd devops-sample-app
docker-compose up -d
