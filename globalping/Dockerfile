ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN \
    apk add --no-cache \
        nodejs \
        npm \
        python3 \
        py3-pip \
        curl \
        jq \
        bash \
        ca-certificates \
    && npm install -g @globalping/cli \
    && pip3 install --no-cache-dir \
        requests \
        flask \
        pyyaml

# Copy root filesystem
COPY rootfs/ /

# Set execute permissions
RUN chmod a+x /usr/bin/run.sh

# Labels
LABEL \
    io.hass.name="Globalping Network Diagnostics" \
    io.hass.description="Run network diagnostics from globally distributed probes" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="robbo600 <robbo600@users.noreply.github.com>" \
    org.opencontainers.image.title="Globalping Add-on" \
    org.opencontainers.image.description="Network diagnostics with Globalping" \
    org.opencontainers.image.source="https://github.com/robbo600/ha-globalping-addon" \
    org.opencontainers.image.licenses="MIT"

# Default command
CMD ["/usr/bin/run.sh"]