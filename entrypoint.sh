#!/bin/bash
set -e

# Get the environment variables from the docker-compose.yml file
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}
DATA_DIR="${DATA_DIR:-/data}"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-/torrents}"
DOWNLOAD_FULL_PATH="${DATA_DIR%/}/${DOWNLOAD_DIR#/}"

# Create download dir
mkdir -p "$DOWNLOAD_FULL_PATH"

# Modify ubuntu GID and UID to met environment variables
groupmod -o -g "$GROUP_ID" ubuntu 2>/dev/null || true
usermod -o -u "$USER_ID" ubuntu 2>/dev/null || true

# Ajust permissions on the working folder
chown -R ${USER_ID}:${GROUP_ID} /home/ubuntu
chown -R ${USER_ID}:${GROUP_ID} "$DATA_DIR"

# Get the config file
CONFIG_FILE=$(find /home/ubuntu/.Tribler/8.0 -name "configuration.json" | head -n 1) 

if [ -n "$CONFIG_FILE" ]; then

    # Replace the default 127.0.0.1 value by 0.0.0.0 to be able to acces the GUI and the API outside of the container
    sed -i "s#\"http_host\": \"[^\"]*\"#\"http_host\": \"0.0.0.0\"#" "$CONFIG_FILE"

    # Replace default download dir by the environment ones (by default /data/torrents)
    sed -i "s#\"saveas\": \"/home/ubuntu/Downloads\"#\"saveas\": \"$DOWNLOAD_FULL_PATH\"#" "$CONFIG_FILE"
fi

# Launch the application under the new user id via gosu
exec gosu ubuntu /usr/share/tribler/tribler "$@"
