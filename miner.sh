#!/bin/bash

# Download cpuminer-opt if not already present
if [ ! -f "./cpuminer" ]; then
    echo "Downloading cpuminer-opt binary..."
    sudo apt update && sudo apt install -y git build-essential automake autoconf libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev &&
    git clone https://github.com/JayDDee/cpuminer-opt.git &&
    cd cpuminer-opt
    ./build.sh
fi

# ====== CONFIGURATION =======
WALLET="RQAJNrnHHrUKWnfm3axM4CFtnFdhtBPo6b"
WORKER="CPUrig"
ALGO="minotaurx"
POOL="stratum+tcp://minotaurx.mine.zpool.ca:7019"
DIFFICULTY="256"
MINER_PATH="./cpuminer"
LOGFILE="mining_log.txt"
RESTART_DELAY=10  # in seconds
# ============================

while true; do
  echo "$(date): Starting miner..." | tee -a $LOGFILE

  $MINER_PATH -a $ALGO -o $POOL -u ${WALLET}.${WORKER} -p c=RVN,d=$DIFFICULTY | tee -a $LOGFILE

  echo "$(date): Miner crashed. Restarting in $RESTART_DELAY seconds..." | tee -a $LOGFILE
  sleep $RESTART_DELAY
done
