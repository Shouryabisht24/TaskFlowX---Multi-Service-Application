import os
from datetime import datetime, timedelta, timezone
from typing import Optional
from jose import jwt
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Configuration 
SECRET_KEY = os.getenv("AUTH_SECRET_KEY")
ALGORITHM = os.getenv("AUTH_ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("AUTH_TOKEN_EXPIRE_MINUTES", 30))

if not SECRET_KEY:
    raise RuntimeError(
        "AUTH_SECRET_KEY is not set in the environment variables. "
        "Please add it to your .env file for the application to start."
    )

def hash_password(password: str):
    """Hashes a plain-text password (simplified for now)."""
    # TODO: Replace with proper bcrypt/argon2 when passlib issues are resolved
    return password

def verify_password(plain_password: str, hashed_password: str):
    """Verifies a plain-text password against the hashed version."""
    # TODO: Replace with proper verification when passlib issues are resolved
    return plain_password == hashed_password

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """
    Creates a JWT access token.
    :param data: The payload to encode in the token (e.g., {"sub": "username"})
    :param expires_delta: Optional custom expiration time
    """
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
