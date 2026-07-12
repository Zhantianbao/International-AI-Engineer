import requests

from github_request_error import GitHubRequestError


class GitHubClient:
    _base_url = "https://api.github.com"

    def __init__(self, token=None):
        self.token = token

    def _get_headers(self):
        headers = {
            "Accept": "application/vnd.github+json",
        }

        if self.token:
            headers["Authorization"] = f"token {self.token}"

        return headers

    def _get(self, path):
        try:
            response = requests.get(f"{self._base_url}{path}",
                         headers=self._get_headers(),
                         timeout=10)
            response.raise_for_status()
            
        except requests.exceptions.RequestException as error:
            raise GitHubRequestError(f"GitHub request failed: {error}") from error

        return response.json()

    def get_user(self, username):
        return self._get(f"/users/{username}")

    def get_repos(self, username):
        return self._get(f"/users/{username}/repos")