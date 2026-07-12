from github_api import get_github_user


username = input(
    "Enter github username:"
)


user = get_github_user(username)


if user is None:
    print("Request failed")

else:
    print(
        "Username:",
        user["login"]
    )

    print(
        "Followers:",
        user["followers"]
    )