#!/bin/bash
echo "start setting -e"
set -e
echo "APP_DIR ..."
APP_DIR=${1:-$HOME}
echo "sleeping 10 ..."
sleep 10
echo "autocleaning ..."
sudo apt-get autoclean
echo "installing git ..."
echo "sleeping 10 ..."
sleep 10
echo "autocleaning ..."
sudo apt-get autoclean
sudo apt install --yes git
echo "cloning ..."
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
echo "go to reddit ..."
cd $APP_DIR/reddit
echo "installing bundle ..."
bundle install
echo "installed bundle ..."
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
echo "starting puma ..."
sudo systemctl start puma
echo "enabling puma ..."
sudo systemctl enable puma
echo "puma enabled ..."
