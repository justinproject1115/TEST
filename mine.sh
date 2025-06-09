#!/bin/bash

WALLET="RQAJNrnHHrUKWnfm3axM4CFtnFdhtBPo6b"

# Download cpuminer-opt if not already present
if [ ! -f "./cpuminer" ]; then
    echo "Downloading cpuminer-opt binary..."
    wget https://github.com/JayDDee/cpuminer-opt/releases/download/v3.20.2/cpuminer-opt-linux64.tar.gz -O cpuminer.tar.gz
    tar -xvf cpuminer.tar.gz
    chmod +x cpuminer
    rm cpuminer.tar.gz
fi

# Infinite mining loop with algo switching
while true; do
    echo "Mining minotaurx..."
    ./cpuminer -a minotaurx -o stratum+tcp://minotaurx.mine.zpool.ca:7019 -u $WALLET -p c=RVN &
    PID=$!
    sleep 600
    kill $PID

    echo "Mining X11..."
    ./cpuminer -a x11 -o stratum+tcp://x11.mine.zpool.ca:3533 -u $WALLET -p c=RVN &
    PID=$!
    sleep 600
    kill $PID

    echo "Mining Yescrypt..."
    ./cpuminer -a yescrypt -o stratum+tcp://yescrypt.mine.zpool.ca:6233 -u $WALLET -p c=RVN &
    PID=$!
    sleep 600
    kill $PID
done
