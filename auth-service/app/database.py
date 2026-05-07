import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# 1. Get the Database URL from environment variables
# Example: postgresql://postgres:password@db:5432/authdb
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL")

if not SQLALCHEMY_DATABASE_URL:
    raise RuntimeError(
        "DATABASE_URL is not set in the environment variables. "
        "Please add it to your .env file (e.g., DATABASE_URL=postgresql://user:pass@host:port/db)"
    )

# 2. Create the SQLAlchemy Engine
# For PostgreSQL, we don't need 'check_same_thread' (that's only for SQLite)
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# 3. Create a SessionLocal class
# Each instance of SessionLocal will be a database session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 4. Create the Base class
# Our models (like User) will inherit from this class to map to DB tables
Base = declarative_base()

# 5. Dependency for FastAPI routes
def get_db():
    """
    Dependency that provides a database session to a request 
    and ensures the session is closed after the request is finished.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
