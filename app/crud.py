from sqlalchemy.orm import Session
from app import models, schemas
from app.core.security import get_password_hash
from typing import Optional

def get_user_by_email(db: Session, email: str) -> Optional[models.User]:
    """
    Tìm user bằng email
    """
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate) -> models.User:
    """
    Tạo user mới trong database
    """
    hashed_password = get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        username=user.username,
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user