from sqlalchemy.orm import Session
from app.crud import get_user_by_username, create_user
from app.core.security import verify_password, create_access_token
from app.schemas import UserCreate, UserLogin


def register(db: Session, body: UserCreate):
    if get_user_by_username(db, body.username):
        raise Exception("Username already exists")
    user = create_user(db, body.username, body.email, body.password)
    token = create_access_token({"sub": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}


def login(db: Session, body: UserLogin):
    user = get_user_by_username(db, body.username)
    if not user or not verify_password(body.password, user.password_hash):
        raise Exception("Invalid username or password")
    token = create_access_token({"sub": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}
