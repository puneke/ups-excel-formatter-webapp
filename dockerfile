# Use Python 3.9 slim base
FROM python:3.9-slim-bullseye

# Install system dependencies and LibreOffice (and Java, needed by some LibreOffice components)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        openjdk-11-jre-headless \
        gcc \
        python3-dev \
        build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    HOME=/tmp

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Optional: Check LibreOffice is installed correctly
RUN which soffice && soffice --version || echo "LibreOffice not found"

# Make sure everything is executable
RUN chmod -R 755 /app

# Run the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]