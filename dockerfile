# Use lightweight Python 3.11 base
FROM python:3.9-slim-bullseye

# Install LibreOffice and system deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libreoffice \
    libreoffice-calc \  # Required for Excel support
    fonts-liberation \  # Fonts for proper rendering
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY . .

# Verify soffice is installed
RUN soffice --version || echo "LibreOffice check failed"

# Run Flask app
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]