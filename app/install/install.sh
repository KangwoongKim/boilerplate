#!/bin/bash
set -euo pipefail

echo "==> Python 패키지 설치 시작..."

pip install --no-cache-dir --upgrade pip setuptools wheel
pip install --no-cache-dir -r /app/install/requirements.txt

echo "==> 설치 완료!"
