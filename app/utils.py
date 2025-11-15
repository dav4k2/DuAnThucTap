from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import jwt
from .config import settings
from itsdangerous import URLSafeTimedSerializer
import smtplib
from email.message import EmailMessage

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
serializer = URLSafeTimedSerializer(settings.SECRET_KEY)

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain, hashed) -> bool:
    return pwd_context.verify(plain, hashed)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")
    return encoded_jwt

def generate_reset_token(email: str) -> str:
    return serializer.dumps(email, salt="password-reset-salt")

def verify_reset_token(token: str, max_age: int = None):
    max_age = max_age or settings.RESET_TOKEN_EXPIRE_SECONDS
    try:
        email = serializer.loads(token, salt="password-reset-salt", max_age=max_age)
        return email
    except Exception:
        return None

def send_reset_email(to_email: str, reset_token: str):
    reset_link = f"https://your-frontend/reset-password?token={reset_token}"
    msg = EmailMessage()
    msg["Subject"] = "Reset mật khẩu"
    msg["From"] = settings.FROM_EMAIL
    msg["To"] = to_email
    msg.set_content(f"Nhấn link để reset mật khẩu: {reset_link}\nLink có hiệu lực trong {settings.RESET_TOKEN_EXPIRE_SECONDS//3600} giờ.")
    # SMTP
    with smtplib.SMTP(settings.SMTP_HOST, settings.SMTP_PORT) as server:
        server.starttls()
        server.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
        server.send_message(msg)