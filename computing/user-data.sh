#!/bin/bash

sudo apt update -y &&
sudo apt install -y nginx

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo systemctl enable docker

# Install Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
sudo apt install -y curl unzip
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Install CodeBuild Agent
sudo apt install -y ruby-full
sudo apt install -y wget
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install &&
sudo ./install auto
sudo service codedeploy-agent start
sudo systemctl enable codedeploy-agent

# Pull environment variables
sudo aws s3 cp s3://prod-desqk-env /var/www --recursive