from sqlalchemy.orm import Session
from app import models, schemas
from app.core.security import get_password_hash
from typing import Optional, List

#--- User CRUD ---#

def get_user_by_email(db: Session, email: str) -> Optional[models.User]:
    """
    Tìm user bằng email
    """
    return db.query(models.User).filter(models.User.email == email).first()

def get_user_by_username(db: Session, username: str) -> Optional[models.User]:
    """
    Tìm user bằng username
    """
    return db.query(models.User).filter(models.User.username == username).first()

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

def update_user_profile(db: Session, user_id: int, profile_data: dict) -> Optional[models.User]:
    """
    Cập nhật thông tin cá nhân và khảo sát của user
    profile_data là một dict chứa các trường: display_name, bio, country, cooking_level, interested_categories,...
    """
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user:
        for key, value in profile_data.items():
            setattr(db_user, key, value)
        
        # Sau khi cập nhật khảo sát, đánh dấu đã hoàn tất profile
        db_user.is_profile_completed = True
        
        db.commit()
        db.refresh(db_user)
    return db_user

# --- RECIPE CRUD ---

def get_recipe(db: Session, recipe_id: int) -> Optional[models.Recipe]:
    """
    Lấy chi tiết 1 công thức kèm thông tin author (nhờ relationship đã định nghĩa trong model)
    """
    return db.query(models.Recipe).filter(models.Recipe.id == recipe_id).first()

def get_recipes(db: Session, skip: int = 0, limit: int = 100) -> List[models.Recipe]:
    """
    Lấy danh sách công thức, hỗ trợ phân trang
    """
    return db.query(models.Recipe).offset(skip).limit(limit).all()

def create_recipe(db: Session, recipe: schemas.RecipeCreate, user_id: int) -> models.Recipe:
    """
    Tạo recipe mới và gán author_id là user đang đăng nhập
    """
    db_recipe = models.Recipe(
        **recipe.model_dump(), # Pydantic v2: dump dữ liệu thành dict
        author_id=user_id      # Gán tác giả là user hiện tại
    )
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    return db_recipe
    
    