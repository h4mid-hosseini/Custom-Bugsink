#!/bin/bash
# Bugsink VPS Deployment Script
# Run this script on your VPS after uploading the project files

set -e

echo "🚀 Starting Bugsink deployment..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root. Please run as a regular user with sudo access."
   exit 1
fi

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker and Docker Compose
echo "🐳 Installing Docker and Docker Compose..."
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install nginx and certbot
echo "🌐 Installing nginx and certbot..."
sudo apt install -y nginx certbot python3-certbot-nginx

# Create bugsink directory if it doesn't exist
if [ ! -d "bugsink" ]; then
    mkdir bugsink
    cd bugsink
fi

# Copy nginx configuration
echo "⚙️  Configuring nginx..."
sudo cp bugsink.nginx.conf /etc/nginx/sites-available/bugsink
sudo ln -sf /etc/nginx/sites-available/bugsink /etc/nginx/sites-enabled/

# Test nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

echo "✅ Deployment preparation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update the domain name in bugsink.nginx.conf (change bugsink.yourdomain.com)"
echo "2. Copy .env.example to .env and fill in your values"
echo "3. Run: docker-compose up -d"
echo "4. Get SSL certificate: sudo certbot --nginx -d yourdomain.com"
echo "5. Access your site at https://yourdomain.com"
echo ""
echo "🔐 Generate a secure Django secret key:"
echo "python3 -c 'import secrets; print(secrets.token_urlsafe(50))'"