#!/usr/bin/env bash
# build.sh

# Install LibreOffice (without sudo)
apt-get update -y && apt-get install -y --no-install-recommends libreoffice unoconv

# Install Python dependencies
pip install -r requirements.txt