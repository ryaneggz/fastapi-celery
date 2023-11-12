# Use an official lightweight Python image.
FROM python:3.11-slim

# Set environment variables.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container.
WORKDIR /code

# Copy the dependencies file to the working directory.
COPY requirements.txt .

# Install dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Create a user and group with a specific UID/GID and no password
# Replace 'myuser' with your preferred username
RUN addgroup --system myuser && adduser --system --group myuser

# Change to the non-root user.
USER myuser

# Copy the content of the local src directory to the working directory.
COPY app /code/app

# Command to run on container start.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
