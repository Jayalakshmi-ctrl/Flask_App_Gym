def test_index_route(client):
    """Verify landing page serves status code 200 and loads core configuration assets."""
    response = client.get('/')
    assert response.status_code == 200
    assert b"ACEest FUNCTIONAL FITNESS" in response.data
    assert b"CAPACITY: 150 Users" in response.data

def test_api_valid_program(client):
    """Verify data serialization endpoint returns correct payload schema."""
    response = client.get('/api/program/fat_loss')
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data["name"] == "Fat Loss (FL)"
    assert json_data["color"] == "#e74c3c"
    assert any("Oats Idli" in item for item in json_data["diet"])

def test_api_invalid_program(client):
    """Verify API handles invalid endpoint routes gracefully."""
    response = client.get('/api/program/invalid_key')
    assert response.status_code == 404
    assert response.get_json() == {"error": "Program not found"}
