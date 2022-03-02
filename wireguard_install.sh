#!/bin/bash
# exec &>/tmp/wireguard_boot_script.log
# Run Fail Safe Command
set -euxo pipefail

###############################
### Wireguard Install & Run ###
###############################

# ENV
export CONTAINER_DIR="${HOME_DIR}/Docker/Wireguard"
echo "Created container dir ENV ${CONTAINER_DIR}"
# export ${VULTR_IP}
# export ${WIREGUARD_PORT}
# echo ${VULTR_IP}
# echo ${WIREGUARD_PORT}
# echo ${CONTAINER_DIR}

# Open network port for VPN – firewall
sudo ufw allow ${WIREGUARD_PORT}/udp

## Create dir for Docker container
mkdir -p ${CONTAINER_DIR} && cd "${CONTAINER_DIR}"

# Add ENV for docker-compose.yml use
echo "VULTR_IP=${VULTR_IP}" >> .env
echo "WIREGUARD_PORT=${WIREGUARD_PORT}" >> .env
echo "LETSENCRYPT_EMAIL"=${DEFAULT_EMAIL}
echo "LETSENCRYPT_HOST=${DOMAIN_NAME_1}"

# Import docker-compose.yml
sudo curl -L https://raw.githubusercontent.com/NH3R717/app_wireguard/master/docker-compose.yml > docker-compose.yml
# Build and run container w/ ENV
sudo docker-compose up -d --build

#  set to user permissions
chmod 0750 "${CONTAINER_DIR}"
chown --recursive \
"${USERNAME}":"${USERNAME}" "${CONTAINER_DIR}"
# Remove .env
# sudo rm -f .env

###################################*
### Useful Commands & Notes here ###
###################################*

#? ~ ~ Wait a moment ~ ~ (script below display's Client QR codes)
#sudo docker exec -it wireguard /app/show-peer 1 3 5