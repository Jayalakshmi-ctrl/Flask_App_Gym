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
# ... the rest of your Dockerfile remains exactly the same
