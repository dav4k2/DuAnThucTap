from fastapi import FastAPI
from app.routers import auth, user
from app.database import engine
from app import models

# Tạo các bảng trong database (nếu chưa tồn tại)
# Trong thực tế, bạn nên dùng Alembic để migrate
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Bao gồm router xác thực
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(user.router)

@app.get("/")
def read_root():
    return {"message": "Chào mừng đến với Auth API!"}