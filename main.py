from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import firebase_admin
from firebase_admin import credentials, auth, firestore
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import os
import mimetypes
import cloudinary
import cloudinary.uploader
import shutil
from collections import Counter, defaultdict

mimetypes.add_type('text/css', '.css')
mimetypes.add_type('application/javascript', '.js')

cred = credentials.Certificate("serviceAccountKey.json")
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

db = firestore.client()

app = FastAPI()

cloudinary.config( 
  cloud_name = "dzysold5b", 
  api_key = "259311985559455", 
  api_secret = "74tXcTNDC8W9h1GpWCFJ-w0Kj7o",
  secure = True
)

app.mount("/css", StaticFiles(directory="css"), name="css")
app.mount("/js", StaticFiles(directory="js"), name="js")
app.mount("/images", StaticFiles(directory="images"), name="images")

@app.get("/index.html")
async def read_index(): return FileResponse("index.html")

@app.get("/dashboard.html")
async def read_dashboard(): return FileResponse("dashboard.html")

@app.get("/user.html")
async def read_users_page(): return FileResponse("user.html")

@app.get("/navbar.html")
async def read_navbar(): return FileResponse("navbar.html")

@app.get("/recipe.html")
async def read_recipe(): return FileResponse("recipe.html")

@app.get("/login.html")
async def read_login(): return FileResponse("login.html")

@app.get("/signup.html")
async def read_signup(): return FileResponse("signup.html")

@app.post("/api/upload-image")
async def upload_image(file: UploadFile = File(...)):
    try:
        result = cloudinary.uploader.upload(file.file, folder="cookhub_uploads")
        image_url = result.get("secure_url")
        
        return {"url": image_url}
    except Exception as e:
        print(f"Lỗi upload: {e}")
        return {"error": str(e)}
    
@app.get("/api/get_all_users")
async def get_all_users():
    try:
        docs = db.collection('users').stream()
        users = []
        
        for doc in docs:
            u_data = doc.to_dict()
            users.append({
                "uid": u_data.get('uid', doc.id),
                "email": u_data.get('email', ''),
                "name": u_data.get('display_name', 'Chưa đặt tên'),
                "photo": u_data.get('avatar_url', ''), 
                "disabled": not u_data.get('is_active', True) 
            })
            
        return {"users": users}
    except Exception as e:
        print(f"Lỗi lấy users: {e}")
        return {"error": str(e)}

class UserUpdate(BaseModel):
    display_name: str
    email: str
    disabled: bool
    ban_duration: Optional[str] = None

@app.put("/api/update_user/{uid}")
async def update_user(uid: str, user: UserUpdate):
    try:
        auth.update_user(
            uid,
            email=user.email,
            display_name=user.display_name,
            disabled=user.disabled
        )

        doc_ref = db.collection('users').document(uid)
        if doc_ref.get().exists:
            doc_ref.update({
                'display_name': user.display_name,
                'email': user.email,
                'is_active': not user.disabled 
            })
        else:
            print(f"User {uid} không tồn tại trong Firestore, bỏ qua update DB.")

        return {"message": "Cập nhật thành công cả Auth và Firestore"}
    except Exception as e:
        print(f"Lỗi update: {e}")
        return {"error": str(e)}

@app.delete("/api/delete_user/{uid}")
async def delete_user(uid: str):
    try:
        try:
            auth.delete_user(uid)
        except Exception as auth_error:
            print(f"Cảnh báo xóa Auth: {auth_error}")
        db.collection('users').document(uid).delete()
        
        return {"message": "Đã xóa thành công"}
    except Exception as e:
        print(f"Lỗi xóa user: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/recipes")
async def get_recipes():
    try:
        docs = db.collection_group('published_recipes').stream()
        recipes_data = []
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id 
            
            if 'createdAt' in data and data['createdAt']:
                if hasattr(data['createdAt'], 'strftime'):
                     data['createdAt'] = data['createdAt'].strftime("%d/%m/%Y")
                else:
                     data['createdAt'] = str(data['createdAt'])
            else:
                data['createdAt'] = "N/A"

            recipes_data.append(data)
        return {"recipes": recipes_data}
    except Exception as e:
        print(f"Lỗi lấy recipe: {e}")
        return {"recipes": [], "error": str(e)}

@app.delete("/api/recipes/{recipe_id}")
async def delete_recipe(recipe_id: str):
    try:
        deleted = False
        docs_stream = db.collection_group('published_recipes').stream()
        for doc in docs_stream:
            if doc.id == recipe_id:
                doc.reference.delete()
                deleted = True
                break
        
        if deleted:
            return {"message": "Đã xóa thành công"}
        else:
            return {"message": "Không tìm thấy bài viết"}
    except Exception as e:
        return {"error": str(e)}

class UserCreate(BaseModel):
    uid: str
    email: str
    display_name: str

@app.get("/setting.html")
async def read_setting():
    return FileResponse("setting.html")

@app.get("/api/check-admin-access/{uid}")
async def check_admin_access(uid: str):
    try:
        doc_ref = db.collection('admins').document(uid)
        doc = doc_ref.get()
        
        if doc.exists:
            admin_data = doc.to_dict()
            return {
                "is_admin": True, 
                "name": admin_data.get("name", "Admin"),
                "email": admin_data.get("email", ""),
            }
        else:
            return {"is_admin": False}
            
    except Exception as e:
        print(f"Lỗi check admin: {e}")
        return {"is_admin": False, "error": str(e)}

@app.get("/api/dashboard-stats")
async def get_dashboard_stats():
    try:
        now = datetime.now()
        start_of_month = datetime(now.year, now.month, 1)
        users_ref = db.collection('users')
        all_users = users_ref.stream()
        total_users = 0
        new_users_month = 0
        user_dates = [] 
        list_new_users = []

        for doc in all_users:
            total_users += 1
            user_data = doc.to_dict()
            created_at = user_data.get('created_at')
            
            if created_at:
                try:
                    if isinstance(created_at, str):
                        dt = datetime.fromisoformat(created_at.replace('Z', ''))
                    else:
                        dt = created_at.replace(tzinfo=None)
                    
                    user_dates.append(dt.strftime("%Y-%m"))

                    if dt >= start_of_month:
                        new_users_month += 1
                        list_new_users.append({
                            "id": doc.id,
                            "name": user_data.get('display_name', 'No Name'),
                            "email": user_data.get('email', ''),
                            "date": dt.strftime("%d/%m/%Y")
                        })
                except:
                    pass

        recipes_ref = db.collection_group('published_recipes')
        all_recipes = recipes_ref.stream()
        total_recipes = 0
        new_recipes_month = 0
        tag_counter = Counter()
        recipe_ratings = []
        list_new_recipes = []

        for doc in all_recipes:
            total_recipes += 1
            r_data = doc.to_dict()
            
            created_at = r_data.get('createdAt')
            if created_at:
                try:
                    if isinstance(created_at, str):
                        dt = datetime.fromisoformat(created_at.replace('Z', ''))
                    else:
                        dt = created_at.replace(tzinfo=None)

                    if dt >= start_of_month:
                        new_recipes_month += 1
                        list_new_recipes.append({
                            "id": doc.id,
                            "title": r_data.get('title', 'No Title'),
                            "author": r_data.get('authorName', 'Unknown'),
                            "date": dt.strftime("%d/%m/%Y")
                        })
                except: pass

            tags = r_data.get('tags', [])
            if isinstance(tags, list):
                for tag in tags: tag_counter[tag] += 1
            
            title = r_data.get('title', 'No Title')
            rating = r_data.get('averageRating', 0)
            recipe_ratings.append({'title': title, 'rating': rating})

        user_counts_by_month = Counter(user_dates)
        sorted_months = sorted(user_counts_by_month.keys())
        line_labels = []
        line_data = []
        cumulative_count = 0
        for month in sorted_months:
            count = user_counts_by_month[month]
            cumulative_count += count
            line_labels.append(month)
            line_data.append(cumulative_count)

        most_common_tags = tag_counter.most_common(5)
        pie_labels = [tag[0] for tag in most_common_tags]
        pie_data = [tag[1] for tag in most_common_tags]
        
        recipe_ratings.sort(key=lambda x: x['rating'], reverse=True)
        top_10_recipes = recipe_ratings[:10]
        bar_labels = [r['title'] for r in top_10_recipes]
        bar_data = [r['rating'] for r in top_10_recipes]

        return {
            "summary": {
                "total_users": total_users,
                "total_recipes": total_recipes,
                "new_users_month": new_users_month,
                "new_recipes_month": new_recipes_month
            },
            "lists": {
                "new_users": list_new_users,     
                "new_recipes": list_new_recipes 
            },
            "charts": {
                "pie": {"labels": pie_labels, "data": pie_data},
                "bar": {"labels": bar_labels, "data": bar_data},
                "line": {"labels": line_labels, "data": line_data}
            }
        }

    except Exception as e:
        print(f"Lỗi thống kê: {e}")
        return {"summary": {}, "charts": {}, "lists": {}}
    
class RecipeTagsUpdate(BaseModel):
    tags: list[str]

@app.put("/api/update-recipe-tags/{recipe_id}")
async def update_recipe_tags(recipe_id: str, update_data: RecipeTagsUpdate):
    try:
        docs = db.collection_group('published_recipes').stream()
        target_ref = None
        
        for doc in docs:
            if doc.id == recipe_id:
                target_ref = doc.reference
                break
        
        if target_ref:
            target_ref.update({
                "tags": update_data.tags
            })
            return {"message": "Cập nhật thành công"}
        else:
            raise HTTPException(status_code=404, detail="Không tìm thấy công thức")

    except Exception as e:
        print(f"Lỗi update: {e}")
        raise HTTPException(status_code=500, detail=str(e))