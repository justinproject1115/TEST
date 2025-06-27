#!/bin/bash

# Set up cpuminer-opt for Monero (fixed difficulty)
set -e

echo "🚀 Setting up cpuminer-opt for Monero..."

# Check for root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Please run this script using sudo:"
  echo "   sudo $0"
  exit 1
fi

# 1. Update & install dependencies
apt update && apt install -y git build-essential automake libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make screen

# 2. Clone cpuminer-opt (RandomX compatible fork)
rm -rf cpuminer-opt
git clone https://github.com/JayDDee/cpuminer-opt.git
cd cpuminer-opt

# 3. Build miner
./build.sh

# 4. Ask for wallet
read -rp "🔑 Enter your Monero wallet address: " WALLET

# 5. Set pool & port (fixed difficulty port 80 = very low)
POOL="pool.supportxmr.com:443"

# 6. Start miner in screen session (2 threads)
screen -dmS miner ./cpuminer -a rx/0 -o stratum+tcp://$POOL -u $WALLET -p x -t 2

echo "✅ Miner started in background (screen session 'miner')"
echo "📈 View logs: screen -r miner"
echo "🛑 Stop:      screen -X -S miner quit"
