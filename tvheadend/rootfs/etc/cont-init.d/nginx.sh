#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: NGINX Proxy Manager
# Configures NGINX for use with the NGINX Proxy Manager
# ==============================================================================
declare ingress_path
declare ingress_port

ingress_path=$(bashio::addon.ingress_entry)
# Get assigned Ingress port
ingress_port=$(bashio::addon.ingress_port)

bashio::log.info "Ingress path used for nginx:  ${ingress_path}"

# replace the placeholder with the actual ingress path in the nginx.conf
sed -i "s|<ingress_path>|$ingress_path|g" /etc/nginx/http.d/default.conf

sed -i "s|<ingress_port>|$ingress_port|g" /etc/nginx/http.d/default.conf
