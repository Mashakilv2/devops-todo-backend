import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# Read DB URL from environment variable
DATABASE_URL = os.getenv("DATABASE_URL")

# Fallback for local development if not set
if not DATABASE_URL:
    DATABASE_URL = "sqlite:///./sql_app.db"

# Special handling only if SQLite
if DATABASE_URL.startswith("sqlite"):
    engine = create_engine(
        DATABASE_URL,
        connect_args={"check_same_thread": False}
    )
else:
    engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()
