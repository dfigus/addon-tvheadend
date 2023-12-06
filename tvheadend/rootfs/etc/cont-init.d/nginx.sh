#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: NGINX Proxy Manager
# Configures NGINX for use with the NGINX Proxy Manager
# ==============================================================================
declare ingress_path

ingress_path=$(bashio::addon.ingress_entry)
bashio::log.info "Ingress path used for nginx:  ${ingress_path}"

# replace the placeholder with the actual ingress path in the nginx.conf
sed -i "s|<ingress_path>|$ingress_path|g" /etc/nginx/http.d/default.conf
