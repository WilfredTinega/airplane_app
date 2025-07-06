# Use official Frappe image with bench preinstalled
FROM frappe/bench:version-15

# Set working directory
WORKDIR /home/frappe

# Initialize a new bench environment
RUN bench init --frappe-branch version-15 frappe-bench

# Change to bench directory
WORKDIR /home/frappe/frappe-bench

# Clone your app from GitHub
RUN bench get-app airplane_mode https://github.com/WilfredTinega/airplane_app

# Create a new site
RUN bench new-site airplane.local --admin-password admin --db-root-password root

# Install your app on the site
RUN bench --site airplane.local install-app airplane_mode

# Expose the default port
EXPOSE 8000

# Start the Frappe development server
CMD ["bench", "serve", "--port", "8000", "--site", "airplane.local"]
