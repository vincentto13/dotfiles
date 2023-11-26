#!/bin/bash 

sudo apt update
sudo apt install -y unzip htop qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
