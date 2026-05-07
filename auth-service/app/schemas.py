from pydantic import BaseModel

class UserCreate(BaseModel):
    username: str
    password: str

class UserOut(BaseModel):
    username: str
    id: int
    class Config: from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str