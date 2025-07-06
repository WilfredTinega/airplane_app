FROM frappe/bench:version-15

# Set working directory
WORKDIR /home/frappe

# Init bench (without creating site during build)
RUN bench init --frappe-branch version-15 frappe-bench

WORKDIR /home/frappe/frappe-bench

# Add custom app
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Add supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Start all services (Redis, MariaDB, Frappe)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
