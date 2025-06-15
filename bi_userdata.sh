#!/bin/bash
# System update
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Install Nginx
amazon-linux-extras install nginx1 -y

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Pull and run Metabase on port 3001
docker run -d \
  -p 3001:3000 \
  --name metabase \
  -e "MB_JETTY_HOST=0.0.0.0" \
  metabase/metabase


echo "Waiting 30 seconds for Metabase to start..."
sleep 30


cat > /etc/nginx/conf.d/metabase.conf <<EOF
server {
    listen 80;
    server_name metabase-bi.sky98.store; 

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Reload Nginx to apply the configuration
systemctl reload nginx

# Output the public IP for verification
echo "Metabase should be accessible at:"
echo "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"