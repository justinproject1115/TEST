#!/bin/bash

WALLET="RQAJNrnHHrUKWnfm3axM4CFtnFdhtBPo6b"

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
