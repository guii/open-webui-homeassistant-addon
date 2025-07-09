#!/usr/bin/with-contenv bashio

# Get configuration from Home Assistant
CONNECTION_MODE=$(bashio::config 'connection_mode')
PGID=$(bashio::config 'PGID')
PUID=$(bashio::config 'PUID')
TZ=$(bashio::config 'TZ' 'UTC')

# Set environment variables
export PGID=${PGID}
export PUID=${PUID}
export TZ=${TZ}

bashio::log.info "Starting Open WebUI with connection mode: ${CONNECTION_MODE}"

# Configure based on connection mode
case "${CONNECTION_MODE}" in
    "ingress_noauth")
        bashio::log.info "Configuring for Home Assistant ingress (no auth)"
        # Set environment variables for ingress mode
        export WEBUI_AUTH=False
        export WEBUI_URL="/api/hassio_ingress/$(bashio::addon.slug)"
        export HOST="0.0.0.0"
        export PORT="8080"
        # Additional Open WebUI specific settings for ingress
        export ENABLE_SIGNUP=False
        export WEBUI_SECRET_KEY="$(openssl rand -hex 32)"
        ;;
    "ingress_auth")
        bashio::log.info "Configuring for Home Assistant ingress (with auth)"
        export WEBUI_AUTH=True
        export WEBUI_URL="/api/hassio_ingress/$(bashio::addon.slug)"
        export HOST="0.0.0.0"
        export PORT="8080"
        export WEBUI_SECRET_KEY="$(openssl rand -hex 32)"
        ;;
    "noingress_auth")
        bashio::log.info "Configuring for direct access (with auth)"
        export WEBUI_AUTH=True
        export HOST="0.0.0.0"
        export PORT="8080"
        ;;
    *)
        bashio::log.warning "Unknown connection mode: ${CONNECTION_MODE}, using default"
        export HOST="0.0.0.0"
        export PORT="8080"
        ;;
esac

# Debug: Print environment variables
bashio::log.info "Environment variables:"
bashio::log.info "HOST: ${HOST}"
bashio::log.info "PORT: ${PORT}"
bashio::log.info "WEBUI_URL: ${WEBUI_URL}"
bashio::log.info "WEBUI_AUTH: ${WEBUI_AUTH}"

# Start Open WebUI
bashio::log.info "Starting Open WebUI..."
exec python -m open_webui.main