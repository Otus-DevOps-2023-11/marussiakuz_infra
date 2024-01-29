#!/bin/bash

# Checking if git is installed
if ! command -v git &> /dev/null; then
   echo "Git not found. Installation..."
   sleep 10
   sudo apt update
   sudo apt install --yes git
else
   echo "Git already is installed."
fi

cd ../ && mkdir yc-user && cd yc-user
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install
