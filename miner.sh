#!/bin/bash

WALLET="RQAJNrnHHrUKWnfm3axM4CFtnFdhtBPo6b"

# Download cpuminer-opt if not already present
if [ ! -f "./cpuminer" ]; then
    echo "Downloading cpuminer-opt binary..."
    sudo apt update && sudo apt install -y git build-essential automake autoconf libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev &&
    git clone https://github.com/JayDDee/cpuminer-opt.git &&
    cd cpuminer-opt
    ./build.sh
fi

while true; do
    echo "Mining minotaurx..."
    ./cpuminer -a minotaurx -o stratum+tcp://minotaurx.mine.zpool.ca:7019 -u $WALLET -p c=RVN &
    PID=$!
    sleep 60
    kill $PID

    echo "Mining X11..."
    ./cpuminer -a x11 -o stratum+tcp://x11.mine.zpool.ca:3533 -u $WALLET -p c=RVN &
    PID=$!
    sleep 60
    kill $PID

    echo "Mining Yescrypt..."
    ./cpuminer -a yescrypt -o stratum+tcp://yescrypt.mine.zpool.ca:6233 -u $WALLET -p c=RVN &
    PID=$!
    sleep 60
    kill $PID

    echo "Mining Yespower..."
    ./cpuminer-opt -a yespower -o stratum+tcp://yespower.mine.zpool.ca:6234 -u $WALLET -p c=RVN &
    PID=$!
    sleep 60
    kill $PID
done
