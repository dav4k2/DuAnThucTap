# app/routers/user.py
from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import User
from app.routers.oauth2 import get_current_user
from app.cloudinary_utils import upload_image_to_cloudinary
from app import crud
import json

router = APIRouter(prefix="/users", tags=["User"])

@router.put("/me/profile/update")
async def update_user_profile(
    display_name: str = Form(...),
    bio: str = Form(None),
    country: str = Form(None),
    cooking_level: str = Form(None),
    interested_categories: str = Form(None), 
    avatar: UploadFile = File(None),
    cover: UploadFile = File(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # --- BƯỚC 1: Chuẩn bị dữ liệu (Data Preparation) ---
    # Tạo một dictionary chứa các thông tin cần update
    user_update_data = {
        "display_name": display_name,
        "bio": bio,
        "country": country,
        "cooking_level": cooking_level
    }

    # Xử lý JSON string (interested_categories)
    if interested_categories:
        try:
            user_update_data["interested_categories"] = json.loads(interested_categories)
        except Exception as e:
            # Nếu lỗi parse JSON, có thể log lỗi hoặc bỏ qua tùy logic
            print(f"Error parsing categories: {e}")

    # --- BƯỚC 2: Xử lý Upload ảnh (External Service) ---
    # Logic upload giữ ở Router là hợp lý vì nó là xử lý I/O file
    if avatar:
        avatar_url = upload_image_to_cloudinary(avatar.file, "user_avatars")
        if avatar_url:
            user_update_data["avatar_url"] = avatar_url
            
    if cover:
        cover_url = upload_image_to_cloudinary(cover.file, "user_covers")
        if cover_url:
            user_update_data["cover_url"] = cover_url

    # --- BƯỚC 3: Gọi CRUD để lưu vào Database (Data Access) ---
    # Router không cần biết "commit" hay "add", chỉ cần bảo CRUD "hãy update user này với data này"
    try:
        updated_user = crud.update_user_profile(db, user_id=current_user.id, profile_data=user_update_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    
    return {"message": "Profile updated successfully", "user": updated_user}

@router.get("/me")
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user