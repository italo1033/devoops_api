from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Variável principal usada pelo SQLAlchemy
    DATABASE_URL: str | None = None

    # Variáveis usadas no seu .env
    POSTGRES_USER: str | None = None
    POSTGRES_PASSWORD: str | None = None
    POSTGRES_DB: str | None = None
    POSTGRES_HOST: str | None = None
    POSTGRES_PORT: int | None = None

    APP_DB_USER: str | None = None
    APP_DB_PASSWORD: str | None = None
    APP_DB_NAME: str | None = None

    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
        "extra_fields": "ignore",  # ⬅️ Aceita variáveis extras (ESSENCIAL)
    }

settings = Settings()
