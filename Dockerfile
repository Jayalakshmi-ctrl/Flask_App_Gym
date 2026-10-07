# Multi-stage build setup to guarantee minimal delivery sizes
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- ADD THESE TWO LINES TO COPY YOUR TEST FILES DURING BUILD ---
COPY app/ ./app
COPY tests/ ./tests
# ----------------------------------------------------------------

# Runtime image execution tier
FROM python:3.11-slim AS runner

WORKDIR /app

# Bring over everything built in the first stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

# Configure networking and logging environment variables
EXPOSE 5000
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app

# Start the Flask web application
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
EOF

