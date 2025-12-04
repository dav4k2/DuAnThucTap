from sqlalchemy import Column, Integer, String, Boolean, JSON
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    """
    Mô hình User trong database
    """
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    
    display_name = Column(String, nullable=True)      # Tên hiển thị (Survey 3)
    bio = Column(String, nullable=True)               # Giới thiệu (Survey 3)
    country = Column(String, nullable=True)           # Quốc gia (Survey 3)
    cooking_level = Column(String, nullable=True)     # Trình độ nấu ăn (Survey 1)
    
    # Lưu danh sách các món quan tâm dưới dạng JSON (Survey 2)
    # Ví dụ: ["Món Việt", "Món Hàn"]
    interested_categories = Column(JSON, nullable=True) 
    
    avatar_url = Column(String, nullable=True)        # Link ảnh đại diện
    cover_url = Column(String, nullable=True)         # Link ảnh bìa
    
    is_profile_completed = Column(Boolean, default=False) # Đánh dấu đã xong khảo sát chưa