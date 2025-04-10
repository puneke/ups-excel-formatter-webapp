# Use Python 3.9 slim base
FROM python:3.9-slim-bullseye

# Install system dependencies and LibreOffice (including Java for LibreOffice)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        fonts-liberation \
        openjdk-11-jre-headless \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables for locale and LibreOffice configuration
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV HOME=/tmp

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Optional: Check if LibreOffice is installed
RUN which soffice && soffice --version || echo "LibreOffice check failed"

# Ensure the app files are accessible
RUN chmod -R 755 /app

# Run the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]