from github_client import GitHubClient, GitHubAPIError


def main():
    client = GitHubClient()
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
        print(repo["name"])


if __name__ == "__main__":
    main()