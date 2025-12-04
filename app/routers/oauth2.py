from jose import jwt, JWTError
from datetime import datetime, timedelta
from fastapi import Depends, status, HTTPException
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app import database, models
# 1. IMPORT SETTINGS CỦA BẠN
# (Nếu file của bạn là settings.py thì đổi thành: from app.settings import settings)
from app.core.settings import settings 

# 2. CẤU HÌNH DÙNG BIẾN TỪ SETTINGS
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Lấy từ file settings thay vì điền cứng
SECRET_KEY = settings.SECRET_KEY  # Hoặc settings.SECRET_KEY tùy cách bạn đặt tên
ALGORITHM = settings.ALGORITHM    # Nếu bạn có lưu algorithm trong settings
# Nếu không lưu algorithm trong settings thì cứ để mặc định:
# ALGORITHM = "HS256" 
ACCESS_TOKEN_EXPIRE_MINUTES = settings.ACCESS_TOKEN_EXPIRE_MINUTES

# --- HÀM GET_CURRENT_USER ---
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(database.get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        # Giải mã token dùng SECRET_KEY từ settings
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        
        email: str = payload.get("sub")

        if email is None:
            raise credentials_exception
            
    except JWTError:
        raise credentials_exception
    
    user = db.query(models.User).filter(models.User.email == email).first()

    if user is None:
        raise credentials_exception

    return user