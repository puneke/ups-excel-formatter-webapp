#!/usr/bin/env bash
# build.sh

apt-get update -y
apt-get install -y unoconv

# Install Python dependencies
pip install -r requirements.txt