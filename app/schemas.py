from pydantic import BaseModel, EmailStr
from typing import Optional

# --- User Schemas ---

class UserBase(BaseModel):
    email: EmailStr
    username: str

class UserCreate(UserBase):
    """
    Schema dùng để tạo user (đăng ký)
    """
    password: str

class UserRead(UserBase):
    """
    Schema dùng để đọc/trả về thông tin user
    """
    id: int
    is_active: bool

    class Config:
        from_attributes = True # Pydantic v2 (orm_mode ở v1)

# --- Token Schemas ---

class Token(BaseModel):
    """
    Schema cho JWT Token
    """
    access_token: str
    token_type: str

class TokenData(BaseModel):
    """
    Schema chứa dữ liệu được mã hóa trong JWT
    """
    email: Optional[str] = None