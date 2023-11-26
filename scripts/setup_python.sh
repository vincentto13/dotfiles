#!/bin/bash 

PYTHON_VERSION=3.12

# Get Python version
python_version=$(python3 --version 2>&1)
current_version=$(echo "$python_version" | awk '{print $2}' | cut -d'.' -f1,2)

# Compare the versions
if [ "$current_version" = "$PYTHON_VERSION" ]; then
    echo "Python version matches the target version ($target_version). Exiting."
    #exit 0
fi
echo "Python version ($current_version) does not match the target version ($target_version). Continue with the script."


sudo apt update
sudo apt install -y software-properties-common 
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python$PYTHON_VERSION
sudo curl -sS https://bootstrap.pypa.io/get-pip.py | python$PYTHON_VERSION
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$current_version 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 2
sudo update-alternatives --config python3

sudo apt install python$PYTHON_VERSION-venv
