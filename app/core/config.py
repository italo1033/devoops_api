from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    DATABASE_URL: str

    # pydantic v2 / pydantic-settings configuration
    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
    }


settings = Settings()
