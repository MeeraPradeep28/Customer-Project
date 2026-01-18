# Use full Python 3.10 image (not slim) for easier builds
FROM python:3.10

# Set working directory
WORKDIR /app

# Install system dependencies required for building packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt
COPY requirements.txt .

# Upgrade pip, setuptools, wheel first
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy the rest of the app
COPY . .

# Collect static files (if using Django)
RUN python manage.py collectstatic --noinput

# Expose port 8000
EXPOSE 8000

# Command to run the Django app with Gunicorn
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]
