from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app import crud, schemas, models
from app.database import get_db
from app.core import security
from fastapi.security import OAuth2PasswordBearer

router = APIRouter(
    prefix="/api/recipes",
    tags=["Recipes"]
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/token")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    # Simplified user retrieval for demo purposes
    # In a real app, you'd decode the token and verify
    # Here we assume the token is the email (for simplicity if not using full JWT decode logic here)
    # But wait, auth.py returns a real JWT. We should use a proper dependency.
    # For now, let's reuse the logic if available or just decode simply.
    # To avoid circular imports or complexity, let's assume we have a way to get user.
    # Actually, let's just import the user getter from a common place if it existed.
    # Since it doesn't, I'll implement a basic decode here or just trust the token for now?
    # No, let's do it right.
    try:
        payload = security.decode_access_token(token)
        email: str = payload.get("sub")
        if email is None:
             raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
        
    user = crud.get_user_by_email(db, email=email)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return user

@router.get("/", response_model=List[schemas.RecipeRead])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = crud.get_recipes(db, skip=skip, limit=limit)
    return recipes

@router.post("/", response_model=schemas.RecipeRead)
def create_recipe(
    recipe: schemas.RecipeCreate, 
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    return crud.create_recipe(db=db, recipe=recipe, user_id=current_user.id)

@router.get("/{recipe_id}", response_model=schemas.RecipeRead)
def read_recipe(recipe_id: int, db: Session = Depends(get_db)):
    db_recipe = crud.get_recipe(db, recipe_id=recipe_id)
    if db_recipe is None:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return db_recipe

@router.post("/{recipe_id}/reviews", response_model=schemas.ReviewRead)
def create_review_for_recipe(
    recipe_id: int,
    review: schemas.ReviewCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    db_recipe = crud.get_recipe(db, recipe_id=recipe_id)
    if db_recipe is None:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    return crud.create_review(db=db, review=review, user_id=current_user.id, recipe_id=recipe_id)
