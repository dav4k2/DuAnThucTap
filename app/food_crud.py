from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
import models, schemas
from database import get_db # Hàm lấy DB session

# 1. THÊM MÓN ĂN (CREATE)
def create_food(food: schemas.FoodCreate, db: Session = Depends(get_db)):
    new_food = models.Food(**food.dict()) # Map dữ liệu từ schema sang model
    db.add(new_food)
    db.commit()
    db.refresh(new_food) # Lấy lại ID vừa tạo
    return new_food

# 2. SỬA MÓN ĂN (UPDATE)
def update_food(food_id: int, food_update: schemas.FoodUpdate, db: Session = Depends(get_db)):
    # Tìm món ăn trong DB
    food_query = db.query(models.Food).filter(models.Food.id == food_id)
    food = food_query.first()
    
    if not food:
        raise HTTPException(status_code=404, detail="Không tìm thấy món ăn")

    # Cập nhật dữ liệu
    food_query.update(food_update.dict(), synchronize_session=False)
    db.commit()
    return food_query.first()

# 3. XÓA MÓN ĂN (DELETE)
def delete_food(food_id: int, db: Session = Depends(get_db)):
    food = db.query(models.Food).filter(models.Food.id == food_id).first()
    
    if not food:
        raise HTTPException(status_code=404, detail="Không tìm thấy món ăn")
    
    db.delete(food)
    db.commit()
    return None