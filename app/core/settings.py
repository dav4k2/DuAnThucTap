from pydantic_settings import BaseSettings, SettingsConfigDict
import os

class Settings(BaseSettings):
    # Cấu hình để load từ file .env
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-t")

    # URL kết nối đến PostgreSQL
    # Ví dụ: "postgresql+psycopg2://user:password@localhost:5432/mydb"
    DATABASE_URL: str = "postgresql://postgres:181004@localhost:5432/cooking_db"    
    # Khóa bí mật để tạo JWT
    SECRET_KEY: str = os.getenv("SECRET_KEY", "664c34290d28294b9afedd198f8ec91219177defc65bf8ab65a051a25e00f2ba")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 ngày

settings = Settings()



