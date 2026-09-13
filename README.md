# Mobile App Boilerplate

Flutter 모바일 앱 · FastAPI 백엔드 보일러플레이트

```
boilerplate/
├── app/
│   ├── backend/          # FastAPI
│   ├── mobile/           # Flutter
│   ├── install/          # Dockerfile · install.sh · requirements.txt
│   ├── start.sh          # 컨테이너 기동 스크립트
│   └── .env.dev          # Docker 컨테이너 전용 (SECRET_KEY 등)
├── docker-compose.yml
└── .env                  # ★ 공통 환경 변수
```

## Docker 프로세스

```
docker compose up
  → Dockerfile (app/install/Dockerfile)
    → install.sh → pip install -r requirements.txt (가상환경 없음)
  → generate_env.py → app/.env.dev
  → app/start.sh → db.init_db → uvicorn
```

## 빠른 시작

```bash
cp .env.example .env
cp app/.env.dev.example app/.env.dev
docker compose up --build

# Flutter
cd app/mobile
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

환경 변수는 루트 `.env` 한 곳에서 관리합니다. `APP_SLUG`, `APP_NAME`, `POSTGRES_*` 등을 바꾸면 Docker 컨테이너명·DB·API 설정에 자동 반영됩니다.
