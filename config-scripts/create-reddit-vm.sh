#!/bin/bash
yc compute instance create \
 --name reddit-full-app \
 --hostname reddit-full-app \
 --zone=ru-central1-a \
 --create-boot-disk size=10GB,image-id=fd8k0b72m3c4s4k883gb \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --ssh-key ~/.ssh/marussia.pub
