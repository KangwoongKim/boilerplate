"""앱 설정 — 루트 .env 단일 소스."""

from pathlib import Path
from typing import Self

from pydantic import model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_DIR = Path(__file__).resolve().parents[1]
PROJECT_ROOT = BACKEND_DIR.parent.parent
DOCKER_ENV = Path("/project.env")


def _env_files() -> tuple[Path, ...]:
    paths: list[Path] = []
    if DOCKER_ENV.is_file():
        paths.append(DOCKER_ENV)
    root = PROJECT_ROOT / ".env"
    if root.is_file() and root not in paths:
        paths.append(root)
    local = BACKEND_DIR / ".env"
    if local.is_file():
        paths.append(local)
    return tuple(paths)


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=_env_files(),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_slug: str
    app_name: str
    cors_origins: list[str]

    postgres_user: str
    postgres_password: str
    postgres_db: str
    database_host: str = "localhost"
    database_url: str = ""

    @model_validator(mode="after")
    def assemble_database_url(self) -> Self:
        if not self.database_url.strip():
            self.database_url = (
                f"postgresql+psycopg://{self.postgres_user}:{self.postgres_password}"
                f"@{self.database_host}:5432/{self.postgres_db}"
            )
        return self


settings = Settings()
