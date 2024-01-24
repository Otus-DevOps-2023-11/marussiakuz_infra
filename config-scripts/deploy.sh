#!/bin/bash

# Checking if git is installed
if ! command -v git &> /dev/null; then
   echo "Git not found. Installation..."
   sudo apt update
   sudo apt install git
else
   echo "Git already is installed."
fi

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma
