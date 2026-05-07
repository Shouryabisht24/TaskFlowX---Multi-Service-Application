from fastapi import FastAPI
from .database import engine, Base
from .routers import auth

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Auth Service")

@app.get("/health", tags=["system"])
def health_check():
    return {"status": "healthy", "service": "auth-service"}

app.include_router(auth.router)
