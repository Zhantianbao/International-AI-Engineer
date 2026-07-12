import requests


url = "https://jsonplaceholder.typicode.com/posts"

data = {
    "title": "Learning API",
    "body": "I am learning Python requests",
    "userId": 1
}

response = requests.post(url, json=data)

print(response.status_code)
print(response.json())
