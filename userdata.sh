#!/bin/bash
#─────────────────────────────────────────────────────────────────
# 1. System Update & Install Docker
#─────────────────────────────────────────────────────────────────
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

#─────────────────────────────────────────────────────────────────
# 2. Install Git (to clone your repo) & Docker Compose (optional)
#─────────────────────────────────────────────────────────────────
yum install -y git
curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#─────────────────────────────────────────────────────────────────
# 3. Clone your Sample App Repo
#─────────────────────────────────────────────────────────────────
cd /home/ec2-user
git clone https://github.com/hamzasamla/devops-sample-app.git
cd devops-sample-app

#─────────────────────────────────────────────────────────────────
# 4a. Build & Run Backend (if you need it)
#     (Optional—only if you want your API working)
#─────────────────────────────────────────────────────────────────
docker build -t sample-backend -f Dockerfile.backend .
docker run -d \
  --name sample-backend \
  -p 3000:3000 \
  sample-backend

#─────────────────────────────────────────────────────────────────
# 4b. Build & Run Frontend on host port 8080
#─────────────────────────────────────────────────────────────────
docker build -t sample-frontend -f Dockerfile.frontend .
docker run -d \
  --name sample-frontend \
  -p 8080:80 \
  sample-frontend

#─────────────────────────────────────────────────────────────────
# Now your frontend is at http://<EC2_PUBLIC_IP>:8080
#─────────────────────────────────────────────────────────────────
