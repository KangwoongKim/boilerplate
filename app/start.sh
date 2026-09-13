#!/usr/bin/env bash
set -euo pipefail

export PYTHONPATH="/app/backend:${PYTHONPATH:-}"

if [ -f "/project.env" ]; then
  set -a
  # shellcheck disable=SC1090
  source "/project.env"
  set +a
fi

cd /app/backend
python3 -m db.init_db
exec uvicorn main:app --host 0.0.0.0 --port 8000 --reload
