# Use Python 3.10 base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Collect static files (optional, for Django)
RUN python manage.py collectstatic --noinput

# Expose port Render expects (usually 10000)
EXPOSE 10000

# Start the app with Gunicorn
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:10000"]
