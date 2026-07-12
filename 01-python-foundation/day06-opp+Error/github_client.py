import requests


class GitHubAPIError(Exception):
    pass


class GitHubClient:
    _base_url = 'https://api.github.com'

    def _get(self, path):
        url = f"{self._base_url}{path}"

        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()

        except requests.exceptions.RequestException as error:
            raise GitHubAPIError(f"GitHub API request failed: {error}") from error

        return response.json()

    def get_user(self, username):
        return self._get(f"/users/{username}")

    def get_user_repos(self, username):
        return self._get(f"/users/{username}/repos")

