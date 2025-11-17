from fastapi import APIRouter

router = APIRouter(prefix="/user", tags=["User"])

@router.get("/ping")
def ping():
    return {"message": "User Route OK!"}
