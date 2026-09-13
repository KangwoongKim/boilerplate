FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Seoul

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libpq5 \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY install/ ./install/

RUN chmod +x /app/install/install.sh \
    && /app/install/install.sh

EXPOSE 8000

CMD ["bash", "/app/start.sh"]
