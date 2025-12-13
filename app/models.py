from sqlalchemy import Column, Integer, String, Boolean, JSON, ForeignKey, DateTime
from datetime import datetime
from sqlalchemy.orm import relationship
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
    recipe = relationship("Recipe", back_populates="author")
    
class Recipe(Base):
    """
    Mô hình Recipe trong database
    """
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    illustration_url = Column(String, nullable=False)  # Link ảnh minh họa
    video_url = Column(String, nullable=False)         # Link video hướng dẫn
    name_recipe = Column(String, nullable=False)
    description = Column(String, nullable=False)
    ration = Column(String, nullable=False)          # Số khẩu phần
    time = Column(String, nullable=False)           # Thời gian chuẩn bị
    difficulty = Column(String, nullable=False)     # Độ khó
    ingredients = Column(JSON, nullable=False)  # Danh sách nguyên liệu dưới dạng JSON
    step = Column(JSON, nullable=False)         # Các bước thực hiện dưới dạng JSON
    author_id = Column(Integer, ForeignKey("users.id"),nullable=False)   # ID của user tạo recipe
    author = relationship("User", back_populates="recipe")
    
# --------------------------
#  Saved Recipe (Lưu món)
# --------------------------
class SavedRecipe(Base):
    """
    Mô hình SavedRecipe trong database
    """

    __tablename__ = "saved_recipes"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)       # ID của user lưu món
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)   # ID của món được lưu
    created_at = Column(DateTime, default=datetime.utcnow)                  # Thời gian lưu món

    user = relationship("User")
    recipe = relationship("Recipe")


# --------------------------
#  Comment (Bình luận)
# --------------------------
class Comment(Base):
    """
    Mô hình Comment trong database
    """
    
    __tablename__ = "comments"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)   # Bình luận về món nào
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)       # Bình luận bởi user nào

    content = Column(String, nullable=False)                                # Nội dung bình luận
    created_at = Column(DateTime, default=datetime.utcnow)                  # Thời gian bình luận

    user = relationship("User")
    recipe = relationship("Recipe")


# --------------------------
#  Category (Danh mục món ăn)
# --------------------------
class Category(Base):
    """
    Mô hình Category trong database
    """
    
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)                     # Tên danh mục


# --------------------------
#  Rating (Đánh giá)
# --------------------------
class Rating(Base):
    """
    Mô hình Rating trong database
    """
    
    __tablename__ = "ratings"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)   # Món được đánh giá
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)       # Người đánh giá

    rating = Column(Integer, nullable=False)  # 1–5 sao
    created_at = Column(DateTime, default=datetime.utcnow)                  # Thời gian đánh giá

    user = relationship("User")
    recipe = relationship("Recipe")


# --------------------------
#  Notification (Thông báo)
# --------------------------
class Notification(Base):
    """
    Mô hình Notification trong database
    """
    
    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)    # Người nhận thông báo

    title = Column(String, nullable=False)                         # Tiêu đề thông báo
    content = Column(String, nullable=False)                # Nội dung thông báo    
    is_read = Column(Boolean, default=False)                      # Đánh dấu đã đọc chưa
    created_at = Column(DateTime, default=datetime.utcnow)          # Thời gian tạo thông báo

    user = relationship("User")


# --------------------------
#  Follow (Người theo dõi)
# --------------------------
class Follow(Base):
    """
    Mô hình Follow trong database
    """
    
    __tablename__ = "follows"

    id = Column(Integer, primary_key=True, index=True)
    follower_id = Column(Integer, ForeignKey("users.id"), nullable=False)   # Người theo dõi
    following_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # Người được theo dõi
    created_at = Column(DateTime, default=datetime.utcnow)                  # Thời gian theo dõi

    # Quan hệ giữa follower và following
    follower = relationship("User", foreign_keys=[follower_id])
    following = relationship("User", foreign_keys=[following_id])