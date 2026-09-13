"""FastAPI application entrypoint."""

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from core import settings
from db import ensure_schema


@asynccontextmanager
async def lifespan(_: FastAPI):
    ensure_schema()
    yield


def create_app() -> FastAPI:
    application = FastAPI(
        title=settings.app_name,
        lifespan=lifespan,
    )

    application.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    register_routes(application)
    return application


def register_routes(application: FastAPI) -> None:
    @application.get("/health", tags=["system"])
    def health_check() -> dict[str, str]:
        return {
            "status": "ok",
            "app": settings.app_slug,
        }

    @application.get("/", tags=["system"])
    def root() -> dict[str, str]:
        return {
            "name": settings.app_name,
            "docs": "/docs",
        }


app = create_app()
