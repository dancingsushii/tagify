#!/usr/bin/env bash

# Needs ssh access with sudo user

set -e

HOST="${1:-gtag}"
TAGIFY_PWD="tagify"
T_USER="tagify"
SETTINGS_FILE="Deploy_Settings.toml"
FRONTEND_DIST="dist"
CERTS_DIR="deploy_certs"

if [ ! -f "app/backend/$SETTINGS_FILE" ]; then
    echo "ERROR: Could find settings file: app/backend/$SETTINGS_FILE"
    exit 1
fi

if [ ! -d "app/backend/$CERTS_DIR" ]; then
    echo "ERROR: Could not find cert dir: app/backend/$CERTS_DIR"
    exit 1
fi

echo "Installing tagify to $HOST...."
ssh "$HOST" << EOF
    set -x

    # Check if installer has already been executed
    if [ ! -f .cache/tagify_install ]; then
        mkdir -p .cache

        # Install dependencies
        sudo apt install rsync openssl curl libssl-dev pkg-config whois libcap2-bin build-essential -y
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

        # Mark
        touch .cache/tagify_install
    else
        echo "Installer has already been executed. Skipping."
    fi
EOF

# Copy over backend source
rsync -R --delete --inplace -Pav -e "ssh -i $HOME/.ssh/id_rsa -F $HOME/.ssh/config"\
    --dirs "./app/backend" \
    --exclude .git \
    --exclude certs \
    --exclude tagify_data \
    --exclude target \
    --exclude reference \
    --exclude Cargo.lock \
    "$HOST":~/

# Copy over frontend dist folder
rsync -R --delete --inplace -Pav -e "ssh -i $HOME/.ssh/id_rsa -F $HOME/.ssh/config"\
    --dirs "app/frontend/$FRONTEND_DIST" \
    "$HOST":~/

# Build server
ssh "$HOST" << EOF
    set -x
    cd app/backend
    cargo build --release
EOF

# Save file as string into SERVICE_FILE
read -d '' SERVICE_FILE << EOF || true
[Unit]
Description=Tagify Daemon
After=network.target
Requires=network.target

[Service]
User=$T_USER
Environment="DIST=dist"
Environment="CONFIG_DIR=."
WorkingDirectory=/home/$T_USER
ExecStart=/home/$T_USER/backend

[Install]
WantedBy=multi-user.target
EOF
# RestartSec=10
# Restart=on-abnormal

# Copy over files to tagify user
ssh "$HOST" << EOF
    sudo su

    # Check if user tagify already exists
    id -u $T_USER
    if [ \$? == "1" ]; then
        # Create tagify user with password
        useradd -m -p \$(mkpasswd -m sha-512 $TAGIFY_PWD) -s /bin/bash $T_USER
    fi
    # Stop executing on failure
    set -x

    # Copy files to tagify user
    install -o $T_USER -g $T_USER -mu=wx app/backend/target/release/backend /home/$T_USER
    install -o $T_USER -g $T_USER -mu=rw app/backend/$SETTINGS_FILE /home/$T_USER
    install -o $T_USER -g $T_USER -mu=rwx -D app/backend/$CERTS_DIR/* -t /home/$T_USER/$CERTS_DIR
    install -o $T_USER -g $T_USER -mu=rwx -D app/frontend/$FRONTEND_DIST/* -t /home/$T_USER/$FRONTEND_DIST
    install -o $T_USER -g $T_USER -mu=r app/backend/schema.sql /home/$T_USER

    # Enable port binding below 1024
    setcap 'cap_net_bind_service=+ep' /home/$T_USER/backend

    # Delete secrets on current user
    # rm app/backend/$SETTINGS_FILE
    # rm -r app/backend/$CERTS_DIR

    # Deploy systemd service file
    echo "$SERVICE_FILE" > /lib/systemd/system/tagify.service

    # Reload systemd to acknowledge new service file
    systemctl daemon-reload

    # Register service for bootup
    # systemctl enable tagify.service

    # Start service
    systemctl start tagify.service

    sleep 1
    systemctl status tagify.service
EOF


