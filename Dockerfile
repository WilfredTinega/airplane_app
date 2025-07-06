# Use Python 3.10 slim image as base
FROM python:3.10-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/home/frappe/.local/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl sudo cron supervisor \
    redis-server mariadb-server default-libmysqlclient-dev \
    xvfb libfontconfig wkhtmltopdf libxrender1 libxext6 xfonts-75dpi xfonts-base \
    nodejs npm gnupg libffi-dev libssl-dev \
    python3-dev build-essential libjpeg-dev zlib1g-dev libpq-dev \
    liblcms2-dev libblas-dev libatlas-base-dev libreadline-dev \
    libmysqlclient-dev libxslt1-dev libxml2-dev libwebp-dev && \
    npm install -g yarn && \
    apt-get clean

# Add a user and switch to it
RUN useradd -ms /bin/bash frappe && usermod -aG sudo frappe
USER frappe
WORKDIR /home/frappe

# Install bench CLI
RUN pip install --user frappe-bench

# Init bench (without site to avoid MariaDB connection issues at build time)
RUN bench init --frappe-branch version-15 frappe-bench

WORKDIR /home/frappe/frappe-bench

# Clone your custom app
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Switch back to root to copy supervisord config
USER root
COPY supervisord.conf /etc/supervisord.conf

# Expose Frappe dev port
EXPOSE 8000

# Start supervisord (will start Redis, MariaDB, site setup, and Frappe)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
