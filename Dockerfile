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
    libmariadb-dev libmariadb-dev-compat libxslt1-dev libxml2-dev libwebp-dev && \
    npm install -g yarn && \
    apt-get clean

# Add user
RUN useradd -ms /bin/bash frappe
USER frappe
WORKDIR /home/frappe

# Install bench CLI
RUN pip install --user frappe-bench

# Initialize bench (without site setup)
RUN bench init --frappe-branch version-15 frappe-bench

# Move into bench
WORKDIR /home/frappe/frappe-bench

# Add custom app from GitHub
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Add supervisor config
USER root
COPY supervisord.conf /etc/supervisord.conf

# Expose port
EXPOSE 8000

# Start all services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
