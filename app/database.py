from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.settings import settings

# Tạo engine kết nối đến PostgreSQL
engine = create_engine(settings.DATABASE_URL)

# Tạo session để tương tác với DB
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    """
    Dependency để cung cấp một session database cho mỗi request.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()