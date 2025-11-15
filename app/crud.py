from sqlalchemy.orm import Session
from . import models, schemas, utils

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user_in: schemas.UserCreate):
    hashed = utils.hash_password(user_in.password)
    user = models.User(email=user_in.email, hashed_password=hashed, full_name=user_in.full_name)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

def authenticate_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)
    if not user: return None
    if not utils.verify_password(password, user.hashed_password): return None
    return user

def reset_password(db: Session, email: str, new_password: str):
    user = get_user_by_email(db, email)
    if not user: return None
    user.hashed_password = utils.hash_password(new_password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user