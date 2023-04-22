# syntax=docker/dockerfile:1
# MAINTAINER "Brian Scott <dev@bscott.mozmail.com>"

FROM alpine:3.6

ARG POCKETBASE_VERSION=v0.15.1

# Install the dependencies
RUN apk add --no-cache \
    ca-certificates \
    unzip \
    wget \
    zip \
    zlib-dev \
    bash

RUN mkdir -p /pb_data

# Download Pocketbase and install it for AMD64
ADD https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip /tmp/pocketbase.zip
RUN unzip /tmp/pocketbase.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/pocketbase

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
# Note: You will want to mount your own Litestream configuration file at /etc/litestream.yml in the container.
# Example: https://github.com/benbjohnson/litestream-docker-example or https://litestream.io/guides/docker/
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.8/litestream-v0.3.8-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

# Notify Docker that the container wants to expose a port.
# Pocketbase serve port
# For the litestream server via Prometheus
EXPOSE 8090 
EXPOSE 9090 

# Copy Litestream configuration file & startup script.
COPY etc/litestream.yml /etc/litestream.yml
COPY scripts/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh
RUN chmod +x /usr/local/bin/litestream

# Start Pocketbase
CMD [ "/scripts/run.sh" ]