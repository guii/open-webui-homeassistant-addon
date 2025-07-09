#!/usr/bin/with-contenv bashio

# Get configuration from Home Assistant
PGID=$(bashio::config 'PGID')
PUID=$(bashio::config 'PUID')
TZ=$(bashio::config 'TZ' 'UTC')

# Set environment variables
export PGID=${PGID}
export PUID=${PUID}
export TZ=${TZ}
export DATA_DIR="/data"
export HOST="0.0.0.0"
export PORT="8080"

# Configure for Home Assistant ingress
export WEBUI_BASE_URL="/api/hassio_ingress/$(bashio::addon.slug)"
export WEBUI_AUTH=False
export ENABLE_SIGNUP=False

bashio::log.info "Starting Open WebUI..."
bashio::log.info "HOST: ${HOST}"
bashio::log.info "PORT: ${PORT}"
bashio::log.info "DATA_DIR: ${DATA_DIR}"
bashio::log.info "WEBUI_BASE_URL: ${WEBUI_BASE_URL}"

# Start Open WebUI
exec python -m open_webui.main