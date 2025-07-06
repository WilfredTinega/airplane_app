# Use Python base image (Bench not prebuilt)
FROM python:3.10-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/home/frappe/.local/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl redis-server mariadb-server \
    xvfb libfontconfig wkhtmltopdf \
    libxrender1 libxext6 xfonts-75dpi xfonts-base \
    nodejs npm supervisor && \
    npm install -g yarn && \
    apt-get clean

# Add user
RUN useradd -ms /bin/bash frappe
USER frappe
WORKDIR /home/frappe

# Install bench
RUN pip install --user frappe-bench

# Init bench and get Frappe app
RUN bench init --frappe-branch version-15 frappe-bench

WORKDIR /home/frappe/frappe-bench

# Get your custom app
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Copy supervisord configuration
USER root
COPY supervisord.conf /etc/supervisord.conf

# Expose Frappe's default port
EXPOSE 8000

# Start all services via supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
