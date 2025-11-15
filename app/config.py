from pydantic import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://postgres:181004@localhost:5432/cooking_db"
    SECRET_KEY: str = "40050b497e99f294a7c9807a2b9c7338be316e990ccf0aad3796bd541ee4d6b0"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60*24*7  # 7 days
    SMTP_HOST: str = "smtp.example.com"
    SMTP_PORT: int = 587
    SMTP_USER: str = "noreply@example.com"
    SMTP_PASSWORD: str = "181004"
    FROM_EMAIL: str = "noreply@example.com"
    RESET_TOKEN_EXPIRE_SECONDS: int = 3600  # 1 hour

    class Config:
        env_file = ".env"

settings = Settings()