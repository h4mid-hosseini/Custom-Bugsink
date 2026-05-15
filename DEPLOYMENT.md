# Bugsink VPS Deployment Guide

This guide will help you deploy Bugsink on a VPS with Docker, nginx, and SSL.

## Files Overview

- `docker-compose.yaml` - Docker services configuration
- `bugsink.nginx.conf` - Nginx reverse proxy configuration
- `.env.example` - Environment variables template
- `deploy.sh` - Automated deployment script

## Quick Deployment

### 1. Upload Files to VPS

```bash
# On your local machine
scp docker-compose.yaml bugsink.nginx.conf .env.example deploy.sh user@your-vps:/home/user/

# Or clone the repository
git clone <your-repo-url>
cd bugsink
```

### 2. Run Deployment Script

```bash
# On your VPS
chmod +x deploy.sh
./deploy.sh
```

### 3. Configure Environment

```bash
# Copy and edit environment file
cp .env.example .env
nano .env

# Fill in your values:
# - DB_PASSWORD: Strong database password
# - SECRET_KEY: Generate with `python3 -c 'import secrets; print(secrets.token_urlsafe(50))'`
# - ADMIN_EMAIL: Your admin email
# - ADMIN_PASSWORD: Strong admin password
# - BASE_URL: https://yourdomain.com
```

### 4. Update Domain in Nginx Config

```bash
# Edit nginx configuration
sudo nano /etc/nginx/sites-available/bugsink

# Change 'bugsink.yourdomain.com' to your actual domain
```

### 5. Start Bugsink

```bash
docker-compose up -d
```

### 6. Get SSL Certificate

```bash
sudo certbot --nginx -d yourdomain.com
```

### 7. Access Your Site

- URL: https://yourdomain.com
- Admin: Your ADMIN_EMAIL / ADMIN_PASSWORD

## Manual Deployment (Alternative)

If you prefer to do it manually:

### Install Dependencies

```bash
sudo apt update
sudo apt install docker.io docker-compose nginx certbot python3-certbot-nginx
sudo systemctl enable docker nginx
```

### Configure Services

1. Copy `bugsink.nginx.conf` to `/etc/nginx/sites-available/bugsink`
2. Enable site: `sudo ln -s /etc/nginx/sites-available/bugsink /etc/nginx/sites-enabled/`
3. Copy `.env.example` to `.env` and configure
4. Run `docker-compose up -d`

## Post-Deployment

### Telegram Setup

1. Create a Telegram bot via @BotFather
2. Get your chat ID by messaging the bot and visiting:
   `https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates`
3. In Bugsink admin, add a Messaging Service Config:
   - Kind: Telegram
   - Config:
     ```json
     {
       "bot_token": "YOUR_BOT_TOKEN",
       "chat_id": "YOUR_CHAT_ID"
     }
     ```

### Security

- Change all default passwords
- Keep Docker images updated: `docker-compose pull && docker-compose up -d`
- Set up backups for the database volume
- Monitor logs: `docker-compose logs -f`

### Troubleshooting

```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs web
docker-compose logs db

# Restart services
docker-compose restart

# Check nginx
sudo nginx -t
sudo systemctl status nginx
```

## Support

If you encounter issues, check the logs and ensure all environment variables are set correctly.