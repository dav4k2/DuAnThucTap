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
    is_profile_completed: bool = False

    class Config:
        from_attributes = True # Pydantic v2 (orm_mode ở v1)

class UserAuthor(BaseModel):
    """
    Chỉ hiển thị thông tin công khai của tác giả
    """
    id: int
    username: str
    display_name: Optional[str] = None
    avatar_url: Optional[str] = None
    
    class Config:
        from_attributes = True

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
    
# -- Recipe Schemas ---
class RecipeBase(BaseModel):
    illustration_url: str
    video_url: str
    name_recipe: str
    description: str
    ration: str
    time: str
    difficulty: str
    ingredients: list[str]
    step: list[str]
    
class RecipeCreate(RecipeBase):
    """
    Schema dùng để tạo recipe mới
    """
    pass

class RecipeRead(RecipeBase):
    """
    Schema dùng để đọc/trả về thông tin recipe
    """
    id: int
    author: Optional[UserAuthor] = None

    class Config:
        from_attributes = True