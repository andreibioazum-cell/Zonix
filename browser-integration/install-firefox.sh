#!/bin/bash
# Install Firefox for Zonix OS

echo "Установка Firefox для Zonix OS..."

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends firefox

# Install desktop entry
sudo mkdir -p /usr/share/applications
sudo cp browser-integration/firefox.desktop /usr/share/applications/

# Install launcher
sudo mkdir -p /usr/local/bin
sudo cp browser-integration/firefox-launcher.sh /usr/local/bin/firefox-launcher
sudo chmod +x /usr/local/bin/firefox-launcher

echo "Firefox установлен и настроен для Zonix OS"
