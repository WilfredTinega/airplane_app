FROM frappe/bench:version-15

# Set working directory
WORKDIR /home/frappe

# Initialize bench without creating a site (during build)
RUN bench init --frappe-branch version-15 frappe-bench

# Move into the bench directory
WORKDIR /home/frappe/frappe-bench

# Get your custom app from GitHub
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Expose the dynamic port Render provides (optional)
EXPOSE $PORT

# Start all services (Redis, MariaDB, site setup, Frappe)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
