from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from crud.item import (
    create_item, get_items, get_item, update_item, delete_item
)
from schemas.item import ItemCreate, ItemUpdate, ItemResponse
from core.database import get_db

router = APIRouter(prefix="/items", tags=["Items"])

@router.post("/", response_model=ItemResponse)
def create(item: ItemCreate, db: Session = Depends(get_db)):
    return create_item(db, item)

@router.get("/", response_model=list[ItemResponse])
def read(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return get_items(db, skip, limit)

@router.get("/{item_id}", response_model=ItemResponse)
def read_one(item_id: int, db: Session = Depends(get_db)):
    db_item = get_item(db, item_id)
    if not db_item:
        raise HTTPException(status_code=404, detail="Item não encontrado")
    return db_item

@router.put("/{item_id}", response_model=ItemResponse)
def update(item_id: int, item: ItemUpdate, db: Session = Depends(get_db)):
    db_item = update_item(db, item_id, item)
    if not db_item:
        raise HTTPException(status_code=404, detail="Item não encontrado")
    return db_item

@router.delete("/{item_id}", response_model=ItemResponse)
def delete(item_id: int, db: Session = Depends(get_db)):
    db_item = delete_item(db, item_id)
    if not db_item:
        raise HTTPException(status_code=404, detail="Item não encontrado")
    return db_item
