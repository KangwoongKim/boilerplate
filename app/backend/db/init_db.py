"""DB 스키마 동기화 — models.py 기준 create_all.

수동 실행:
  docker compose exec api python3 -m db.init_db
"""

from __future__ import annotations

import logging
import threading
import time

from sqlalchemy.exc import OperationalError

from db.base import Base
from db.session import engine

logger = logging.getLogger(__name__)

_lock = threading.Lock()
_schema_ready = False


def ensure_schema(*, retries: int = 10, retry_delay: float = 2.0) -> None:
    """PostgreSQL 준비 후 누락 테이블 생성. 프로세스당 1회 실행."""
    global _schema_ready

    if _schema_ready:
        return

    with _lock:
        if _schema_ready:
            return

        import db.models  # noqa: F401 — Base.metadata 에 모델 등록

        last_error: Exception | None = None
        for attempt in range(1, retries + 1):
            try:
                Base.metadata.create_all(bind=engine)
                logger.info("Database schema ready")
                _schema_ready = True
                return
            except OperationalError as exc:
                last_error = exc
                if attempt >= retries:
                    break
                logger.warning(
                    "Database not ready (%s/%s): %s",
                    attempt,
                    retries,
                    exc,
                )
                time.sleep(retry_delay)

        if last_error is not None:
            raise last_error


def main() -> None:
    logging.basicConfig(level=logging.INFO)
    ensure_schema()
    print("Schema sync complete.")


if __name__ == "__main__":
    main()
