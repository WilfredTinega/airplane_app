FROM python:3.10-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install OS dependencies
RUN apt-get update && apt-get install -y \
    git curl sudo cron supervisor \
    redis-server mariadb-server \
    xvfb libfontconfig wkhtmltopdf libxrender1 libxext6 xfonts-75dpi xfonts-base \
    nodejs npm gnupg libffi-dev libssl-dev \
    python3-dev build-essential libjpeg-dev zlib1g-dev libpq-dev \
    liblcms2-dev libblas-dev libatlas-base-dev libreadline-dev \
    libmariadb-dev-compat libmariadb-dev \
    libxslt1-dev libxml2-dev libwebp-dev && \
    npm install -g yarn && \
    apt-get clean

# Create user
RUN useradd -ms /bin/bash frappe
USER frappe
WORKDIR /home/frappe

# Install bench
RUN pip install frappe-bench

# Init bench
RUN bench init --frappe-branch version-15 frappe-bench
WORKDIR /home/frappe/frappe-bench

# Get custom app
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Add supervisord config
USER root
COPY supervisord.conf /etc/supervisord.conf

# Expose Frappe port
EXPOSE 8000

# Run Supervisor (starts MariaDB, Redis, Site init, Frappe server)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
