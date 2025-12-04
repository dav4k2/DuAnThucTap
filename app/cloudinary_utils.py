import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url

# Configuration       
cloudinary.config( 
    cloud_name = "dzysold5b", 
    api_key = "259311985559455", 
    api_secret = "74tXcTNDC8W9h1GpWCFJ-w0Kj7o", # Click 'View API Keys' above to copy your API secret
    secure=True
)

def upload_image_to_cloudinary(file_obj, folder_name: str) -> str:
    """
    Upload file object lên Cloudinary và trả về URL
    """
    try:
        response = cloudinary.uploader.upload(
            file_obj,
            folder=folder_name,
            resource_type="image"
        )
        return response.get("secure_url")
    except Exception as e:
        print(f"Cloudinary upload error: {e}")
        return None