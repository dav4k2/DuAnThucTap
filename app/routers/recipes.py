from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app import crud, schemas, models
from app.database import get_db
from app.core import security
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError # Cần import lỗi của thư viện JWT (thường là python-jose)

router = APIRouter(
    prefix="/api/recipes",
    tags=["Recipes"]
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/token")

# --- DEPENDENCY: Lấy User hiện tại ---
# (Khuyên dùng: Nên chuyển hàm này sang file app/dependencies.py để dùng chung cho cả router khác)
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> models.User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = security.decode_access_token(token)
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError: # Bắt lỗi giải mã token
        raise credentials_exception
        
    user = crud.get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user

# --- API ENDPOINTS ---

@router.get("/", response_model=List[schemas.RecipeRead])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """
    Lấy danh sách công thức. 
    Kết quả sẽ bao gồm cả thông tin tác giả (author) nhờ vào schemas.RecipeRead.
    """
    recipes = crud.get_recipes(db, skip=skip, limit=limit)
    return recipes

@router.post("/", response_model=schemas.RecipeRead)
def create_recipe(recipe: schemas.RecipeCreate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    """
    Tạo công thức mới. Yêu cầu đăng nhập.
    """
    return crud.create_recipe(db=db, recipe=recipe, user_id=current_user.id)

@router.get("/{recipe_id}", response_model=schemas.RecipeRead)
def read_recipe(recipe_id: int, db: Session = Depends(get_db)):
    """
    Xem chi tiết một công thức.
    """
    db_recipe = crud.get_recipe(db, recipe_id=recipe_id)
    if db_recipe is None:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return db_recipe

@router.delete("/{recipe_id}", status_code=204)
def delete_recipe(recipe_id: int, db: Session = Depends(get_db),current_user: models.User = Depends(get_current_user)):
    """
    Xóa một công thức. Yêu cầu đăng nhập.
    """
    db_recipe = crud.get_recipe(db, recipe_id=recipe_id)
    if db_recipe is None:
        raise HTTPException(status_code=404, detail="Recipe not found")
    if db_recipe.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this recipe")
    
    db.delete(db_recipe)
    db.commit()
    return None