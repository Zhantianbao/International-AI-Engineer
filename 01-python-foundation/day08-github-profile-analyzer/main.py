import os

from pathlib import Path

from dotenv import load_dotenv

from github_client import GitHubClient

from github_request_error import GitHubRequestError

from analyzer import Analyzer

from file_utils import save_to_json


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

    username = input("Enter GitHub username: ")

    try:
        user = client.get_user(username)
        repos = client.get_repos(username)

    except GitHubRequestError as error:
        print(error)
        return

    analyzer = Analyzer(user, repos)

    data = analyzer.get_data()

    save_to_json(data, "report.json")

    analyzer.display_data(data)


if __name__ == "__main__":
    main()