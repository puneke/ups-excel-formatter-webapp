# Use Python 3.9 slim base
FROM python:3.9-slim-bullseye

# Install system dependencies and LibreOffice
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        fonts-liberation \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Optional: Check if LibreOffice is installed
RUN which soffice && soffice --version || echo "LibreOffice check failed"

# Set environment variable to avoid LibreOffice dialogs
ENV HOME=/tmp

# Run the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]