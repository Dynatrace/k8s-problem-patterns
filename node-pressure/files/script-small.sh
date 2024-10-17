#!/bin/sh

set -eu

echo "INFO: Parallel processing small init."
apk update > /dev/null 2>&1
apk add curl stress-ng kubectl > /dev/null 2>&1
sleep 60

while true
do
  echo "INFO: Adding additional worker (small instance)."
  stress-ng --vm 1 --vm-bytes 50m --vm-hang 0 -t 1y > /dev/null 2>&1 &
  sleep 30
done
