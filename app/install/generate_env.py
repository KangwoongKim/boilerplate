"""컨테이너 기동 시 app/.env.dev에 SECRET_KEY 등을 생성합니다."""

import os
import secrets


def generate_secret_key() -> str:
    return secrets.token_hex(32)


def update_env_file() -> None:
    env_path = "/app/.env.dev"

    lines: list[str] = []
    if os.path.exists(env_path):
        with open(env_path, encoding="utf-8") as f:
            lines = f.readlines()

        if any(line.startswith("SECRET_KEY=") for line in lines):
            return

    lines.append(f"SECRET_KEY={generate_secret_key()}\n")

    with open(env_path, "w", encoding="utf-8") as f:
        f.writelines(lines)


if __name__ == "__main__":
    update_env_file()
