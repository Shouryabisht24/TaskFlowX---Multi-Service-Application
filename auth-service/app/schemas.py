from pydantic import BaseModel, field_validator

class UserCreate(BaseModel):
    username: str
    password: str
    
    @field_validator('password')
    def validate_password(cls, v):
        if len(v) > 72:
            raise ValueError('Password cannot be longer than 72 characters')
        if len(v) < 6:
            raise ValueError('Password must be at least 6 characters')
        return v
    
    @field_validator('username')
    def validate_username(cls, v):
        if len(v) < 3:
            raise ValueError('Username must be at least 3 characters')
        if len(v) > 50:
            raise ValueError('Username cannot be longer than 50 characters')
        return v

class UserOut(BaseModel):
    username: str
    id: int
    class Config: 
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
