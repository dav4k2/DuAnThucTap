# Sử dụng một image Python 3.11-slim (nhẹ)
FROM python:3.11-slim

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Cập nhật pip và cài đặt psycopg2-binary
# Tách ra để build nhanh hơn nếu requirements không đổi
RUN pip install --upgrade pip
RUN pip install psycopg2-binary

# Copy file requirements.txt VÀO TRƯỚC
COPY requirements.txt .

# Cài đặt các thư viện trong requirements.txt
# --no-cache-dir để giữ image nhẹ
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ code (thư mục app, v.v...) vào container
COPY . .

# Mở port 8000 để container có thể nhận request
EXPOSE 8000

# Lệnh để chạy app khi container khởi động
# Dùng "0.0.0.0" để có thể truy cập từ bên ngoài container
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]