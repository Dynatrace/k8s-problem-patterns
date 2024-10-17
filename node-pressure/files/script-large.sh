#!/bin/sh

set -eu

apk update > /dev/null 2>&1
apk add curl stress-ng kubectl > /dev/null 2>&1
echo "INFO: Parallel processing large init."

while [ "$(kubectl get node "$NODE_NAME" -o jsonpath='{.status.conditions[?(@.type=="MemoryPressure")].status}')" = "True" ]
do
  echo "ERROR: Failed to allocate more memory. Can't add more workers at the moment." 1>&2
  sleep 10
done

echo "INFO: Adding additional worker (large instance)."
stress-ng --vm 1 --vm-bytes 400m --vm-hang 0 -t 1y > /dev/null 2>&1
