FROM python:3.9-alpine3.16


# Set the working directory
WORKDIR /data

# Install system dependencies
RUN apk add --update --no-cache \
    libxml2-dev \
    libxslt-dev \
    build-base \
    libffi-dev

# Install Python dependencies
RUN pip install --no-cache-dir \
    parsedmarc \
    checkdmarc

# Copy configuration files
COPY config/parsedmarc.sample.ini /srv/parsedmarc/config/
COPY config/kibanaDashboard.ndjson /srv/parsedmarc/config/
COPY config/GeoLite2-Country.mmdb /srv/parsedmarc/config/
COPY README /srv/parsedmarc/config/

# Create directory if it doesn't exist
RUN mkdir -p /srv/parsedmarc/config/

# Create target directory if it doesn't exist
RUN mkdir -p /usr/share/GeoIP/

# Create symbolic link
RUN ln -s /srv/parsedmarc/config/GeoLite2-Country.mmdb /usr/share/GeoIP/GeoLite2-Country.mmdb

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Copy health check server script
COPY health_check_server.py /usr/local/bin/health_check_server.py

# Set permissions for entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/health_check_server.py

# Expose the port for the health check server
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]



