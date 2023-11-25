#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  echo "Detected macOS"
  # macOS doesn't use locale-gen, use system preferences to configure locales
  echo "Locales are configured in System Preferences on macOS."
elif [ -f /etc/debian_version ]; then
  echo "Detected Debian-based system"
  sudo apt-get update && sudo apt-get install locales
  sudo locale-gen pl_PL.UTF-8 en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8 
elif [ -f /etc/alpine-release ]; then
  echo "Detected Alpine Linux"
  # Alpine Linux doesn't use locale-gen, locales are set during installation
  echo "Locales are set during installation on Alpine Linux."
elif [ -f /etc/redhat-release ]; then
  echo "Detected Red Hat-based system"
  sudo localedef -i pl_PL -f UTF-8 pl_PL.UTF-8
else
  echo "Error: Unsupported operating system. Locale configuration may not be required on this system."
fi
