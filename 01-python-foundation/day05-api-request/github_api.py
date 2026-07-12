import requests


def get_github_user(username):

    url = f"https://api.github.com/users/{username}"

    try:
        response = requests.get(url)

    except requests.exceptions.RequestException:
        return None


    if response.status_code != 200:
        return None


    return response.json()