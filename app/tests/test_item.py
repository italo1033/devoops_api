from fastapi import status

def test_create_item(client):
    response = client.post(
        "/items/",
        json={"name": "Test Item", "description": "This is a test item"},
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["name"] == "Test Item"
    assert data["description"] == "This is a test item"
    assert "id" in data

def test_read_items(client):
    # Create an item first
    client.post(
        "/items/",
        json={"name": "Item 1", "description": "Desc 1"},
    )
    client.post(
        "/items/",
        json={"name": "Item 2", "description": "Desc 2"},
    )

    response = client.get("/items/")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert len(data) == 2
    assert data[0]["name"] == "Item 1"

def test_read_item(client):
    # Create an item
    create_response = client.post(
        "/items/",
        json={"name": "Single Item", "description": "Single Desc"},
    )
    item_id = create_response.json()["id"]

    # Read the item
    response = client.get(f"/items/{item_id}")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["name"] == "Single Item"
    assert data["id"] == item_id

def test_read_item_not_found(client):
    response = client.get("/items/999")
    assert response.status_code == status.HTTP_404_NOT_FOUND

def test_update_item(client):
    # Create an item
    create_response = client.post(
        "/items/",
        json={"name": "Old Name", "description": "Old Desc"},
    )
    item_id = create_response.json()["id"]

    # Update the item
    response = client.put(
        f"/items/{item_id}",
        json={"name": "New Name", "description": "New Desc"},
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["name"] == "New Name"
    assert data["description"] == "New Desc"

def test_delete_item(client):
    # Create an item
    create_response = client.post(
        "/items/",
        json={"name": "Delete Me", "description": "Delete Desc"},
    )
    item_id = create_response.json()["id"]

    # Delete the item
    response = client.delete(f"/items/{item_id}")
    assert response.status_code == status.HTTP_200_OK
    
    # Verify it's gone
    get_response = client.get(f"/items/{item_id}")
    assert get_response.status_code == status.HTTP_404_NOT_FOUND
