#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y curl git
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
cd /home
sudo git clone https://github.com/ybborowski/B2RISE-gcp-challenge.git projeto-api
cd projeto-api/api
sudo npm install
sudo npm run build || echo "Nenhum build necessário"
sudo pm2 start dist/index.js --name typescript-api
sudo pm2 startup systemd
sudo pm2 save
sudo echo "FINISHED."
