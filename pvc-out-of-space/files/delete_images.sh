#!/bin/sh

set -eu

echo "Downloading regclient..."
wget https://github.com/regclient/regclient/releases/latest/download/regctl-linux-amd64 -O regctl --quiet
chmod 755 regctl
echo "done"

echo "Listing images..."
images="$(./regctl tag list "zot.${NAMESPACE}:5000/big-image" --host "user=admin,pass=$REG_PW,reg=zot.${NAMESPACE}:5000,tls=disabled")"
echo "$images"
echo "done"

echo "Deleting images..."
for image in $images;
do
  echo "Deleting big-image:${image}..."
  ./regctl tag delete "zot.${NAMESPACE}:5000/big-image:${image}" --host "user=admin,pass=$REG_PW,reg=zot.${NAMESPACE}:5000,tls=disabled"
  echo "deleted big-image:${image}"
done
echo "done deleting images"