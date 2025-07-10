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
INGRESS_PATH="/api/hassio_ingress/$(bashio::addon.slug)"
export WEBUI_BASE_URL="${INGRESS_PATH}"
export WEBUI_URL="${INGRESS_PATH}"
export WEBUI_URL_PREFIX="${INGRESS_PATH}"
export BASE_URL="${INGRESS_PATH}"
export WEBUI_AUTH=False
export ENABLE_SIGNUP=False
export WEBUI_SECRET_KEY="$(openssl rand -hex 32)"
# Additional reverse proxy settings
export WEBUI_REVERSE_PROXY=True
export WEBUI_TRUST_PROXY=True
# Try FastAPI specific settings
export ROOT_PATH="${INGRESS_PATH}"
export SCRIPT_NAME="${INGRESS_PATH}"

bashio::log.info "Starting Open WebUI..."
bashio::log.info "HOST: ${HOST}"
bashio::log.info "PORT: ${PORT}"
bashio::log.info "DATA_DIR: ${DATA_DIR}"
bashio::log.info "INGRESS_PATH: ${INGRESS_PATH}"
bashio::log.info "WEBUI_BASE_URL: ${WEBUI_BASE_URL}"
bashio::log.info "WEBUI_URL_PREFIX: ${WEBUI_URL_PREFIX}"
bashio::log.info "ROOT_PATH: ${ROOT_PATH}"
bashio::log.info "SCRIPT_NAME: ${SCRIPT_NAME}"

# Start Open WebUI with root path for ingress
exec python -m open_webui.main --root-path "${INGRESS_PATH}"