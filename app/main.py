from fastapi import FastAPI
from core.database import Base, engine
from api.routes.item import router as items


Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI CRUD PostgreSQL")


@app.get("/")
def root():
    return {"message": "API funcionando com PostgreSQL!"}


app.include_router(items)
