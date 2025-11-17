from fastapi import FastAPI
from app.routers import auth
from app.database import engine
from app import models

# Tạo các bảng trong database (nếu chưa tồn tại)
# Trong thực tế, bạn nên dùng Alembic để migrate
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Auth API cho Flutter App",
    description="Backend API sử dụng FastAPI và PostgreSQL cho việc xác thực người dùng.",
    version="1.0.0"
)

# Bao gồm routerxác thực
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])

@app.get("/")
def read_root():
    return {"message": "Chào mừng đến với Auth API!"}