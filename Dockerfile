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

# Create directory if it doesn't exist
RUN mkdir -p /srv/parsedmarc/config/

# Create target directory if it doesn't exist
RUN mkdir -p /usr/share/GeoIP/

# Copy configuration files
COPY config/GeoLite2-Country.mmdb /srv/parsedmarc/config/
COPY config/parsedmarc.sample.ini /srv/parsedmarc/config/

COPY config/kibanaDashboard.ndjson /data/
COPY config/kibanaDashboard-v2.ndjson /data/
COPY README /data/

# Create symbolic link
RUN ln -s /srv/parsedmarc/config/GeoLite2-Country.mmdb /usr/share/GeoIP/GeoLite2-Country.mmdb

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions for entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]



