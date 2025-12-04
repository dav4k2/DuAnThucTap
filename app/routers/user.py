# app/routers/user.py
from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import User
from app.routers.oauth2 import get_current_user
from app.cloudinary_utils import upload_image_to_cloudinary # Import helper
import json

router = APIRouter(prefix="/users", tags=["User"])

@router.put("/me/profile/update")
async def update_user_profile(
    display_name: str = Form(...),
    bio: str = Form(None),
    country: str = Form(None),
    cooking_level: str = Form(None),
    interested_categories: str = Form(None), # Nhận JSON string
    avatar: UploadFile = File(None),
    cover: UploadFile = File(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # 1. Update Text Data
    current_user.display_name = display_name
    current_user.bio = bio
    current_user.country = country
    current_user.cooking_level = cooking_level
    
    if interested_categories:
        try:
            # Parse chuỗi JSON từ client thành List Python để lưu vào cột JSON
            current_user.interested_categories = json.loads(interested_categories)
        except Exception as e:
            print(f"Error parsing categories: {e}")
            pass

    # 2. Xử lý upload ảnh lên Cloudinary
    if avatar:
        # .file là file object binary
        avatar_url = upload_image_to_cloudinary(avatar.file, "user_avatars")
        if avatar_url:
            current_user.avatar_url = avatar_url
            
    if cover:
        cover_url = upload_image_to_cloudinary(cover.file, "user_covers")
        if cover_url:
            current_user.cover_url = cover_url

    # Đánh dấu đã hoàn thành profile
    current_user.is_profile_completed = True

    try:
        db.commit()
        db.refresh(current_user)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    
    return {"message": "Profile updated successfully", "user": current_user}

@router.get("/me")
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user