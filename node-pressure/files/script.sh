#!/bin/sh

set -eu

apk update
apk add curl stress-ng kubectl

if [ "$(kubectl get node "$NODE_NAME" -o jsonpath='{.status.conditions[?(@.type=="MemoryPressure")].status}')" = "False" ]; then 
    echo "No pressure; allocating memory"
    stress-ng --vm 1 --vm-bytes 16g --vm-hang 0
else 
    echo "Sleeping..."
    sleep 10000d
fi
