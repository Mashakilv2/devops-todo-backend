# ===== BUILD STAGE =====
FROM python:3.11-slim AS build

WORKDIR /app

# Copy requirements first for layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# ===== PRODUCTION STAGE =====
FROM python:3.11-slim AS runtime

WORKDIR /app

# Create non-root user for security
RUN useradd -m appuser
USER appuser

# Copy dependencies and app from build stage
COPY --from=build --chown=appuser:appuser /app /app

# Expose port
EXPOSE 4000

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Start the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "4000"]