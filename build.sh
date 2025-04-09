#!/usr/bin/env bash
# build.sh

# Install LibreOffice
sudo apt-get update
sudo apt-get install -y libreoffice

# Install Python dependencies
pip install -r requirements.txt