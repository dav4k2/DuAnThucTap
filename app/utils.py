from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import jwt
from app.core.settings import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Mã hóa mật khẩu
def get_password_hash(hashed_password: str):
    return pwd_context.hash(hashed_password)

# Kiểm tra mật khẩu lúc đăng nhập
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

# Tạo JWT Token
def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=30) # Mặc định 30 phút
    
    to_encode.update({"exp": expire})
    # SECRET_KEY và ALGORITHM nên lấy từ biến môi trường
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")
    return encoded_jwt