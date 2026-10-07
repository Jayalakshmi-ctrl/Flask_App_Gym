# Multi-stage build setup to guarantee minimal delivery sizes
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app
COPY tests/ ./tests

# Runtime image execution tier
FROM python:3.11-slim AS runner

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

EXPOSE 5000
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app

CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
