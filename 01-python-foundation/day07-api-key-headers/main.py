import os
from pathlib import Path

from dotenv import load_dotenv

from github_client import GitHubClient, GitHubAPIError


def main():
    project_root = Path(__file__).resolve().parents[2]

    dotenv_path = project_root / ".env"

    load_dotenv(dotenv_path)

    token = os.getenv("GITHUB_TOKEN")

    if token:
        print("GitHub token loaded")
    else:
        print("GitHub token not found")

    client = GitHubClient(token)
    username = input(
        "Enter github username: "
    )

    try:
        user = client.get_user(username)
        repos = client.get_user_repos(username)
    except GitHubAPIError as error:
        print(error)
        return

    print("Username:", user["login"])
    print("Followers:", user["followers"])
    print("\nRepos:", len(repos))

    for repo in repos[:5]:
        name = repo.get("name", "unknown")
        stars = repo.get("stargazers_count", "0")
        language = repo.get("language") or "unknown"
        updated_at = repo.get("updated_at", "unknown")

        print(f"- {name} | Stars: {stars} | Language: {language} | Updated at: {updated_at}")


if __name__ == "__main__":
    main()