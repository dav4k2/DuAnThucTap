from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from . import models, schemas, crud, deps, utils
from .database import engine
from .config import settings

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Auth API")

@app.post("/register", response_model=schemas.UserOut)
def register(user_in: schemas.UserCreate, db: Session = Depends(deps.get_db)):
    if crud.get_user_by_email(db, user_in.email):
        raise HTTPException(status_code=400, detail="Email đã tồn tại")
    user = crud.create_user(db, user_in)
    return user

@app.post("/login", response_model=schemas.Token)
def login(data: schemas.LoginIn, db: Session = Depends(deps.get_db)):
    user = crud.authenticate_user(db, data.email, data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Email hoặc mật khẩu không đúng")
    token = utils.create_access_token({"sub": str(user.id), "email": user.email})
    return {"access_token": token, "token_type": "bearer"}

@app.post("/forgot-password")
def forgot_password(body: schemas.ResetRequestIn, db: Session = Depends(deps.get_db)):
    user = crud.get_user_by_email(db, body.email)
    if not user:
        # tránh leak email existence => return 200 anyway
        return {"msg": "Nếu email tồn tại, bạn sẽ nhận được hướng dẫn reset"}
    token = utils.generate_reset_token(user.email)
    utils.send_reset_email(user.email, token)
    return {"msg": "Nếu email tồn tại, bạn sẽ nhận được hướng dẫn reset"}

@app.post("/reset-password")
def reset_password(body: schemas.ResetPasswordIn, db: Session = Depends(deps.get_db)):
    email = utils.verify_reset_token(body.token)
    if not email:
        raise HTTPException(status_code=400, detail="Token không hợp lệ hoặc đã hết hạn")
    user = crud.reset_password(db, email, body.new_password)
    if not user:
        raise HTTPException(status_code=404, detail="Người dùng không tồn tại")
    return {"msg": "Đổi mật khẩu thành công"}