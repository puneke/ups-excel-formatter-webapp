#!/usr/bin/env bash
# build.sh

# Update and install LibreOffice with dependencies
apt-get update -y
apt-get install -y --no-install-recommends libreoffice-core libreoffice-writer libreoffice-calc

# Verify installation (debugging)
which soffice || echo "soffice not found!"
ls -l /usr/bin/soffice || echo "No soffice in /usr/bin"

# Install Python dependencies
pip install -r requirements.txt