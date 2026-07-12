class Analyzer:
    def __init__(self, user, repos):
        self.user = user
        self.repos = repos

    def _get_total_stars(self):
        total_stars = 0
        for repo in self.repos:
            total_stars += repo.get("stargazers_count", 0)

        return total_stars

    def _get_most_used_language(self):
        languages = {}
        for repo in self.repos:
            language = repo.get("language")
            if language:
                if language not in languages:
                    languages[language] = 1
                else:
                    languages[language] += 1

            if not languages:
                return "Unknown"

        return max(languages, key=languages.get)

    def _get_top_repos(self):
        sorted_repos = sorted(self.repos, key=lambda repo: repo.get("stargazers_count", 0), reverse=True)

        top_repos = []

        for repo in sorted_repos[:2]:
            top_repos.append({
                "name": repo.get("name", "Unknown"),
                "stars": repo.get("stargazers_count", 0),
                "language": repo.get("language") or "Unknown",
                }
            )

        return top_repos

    def get_data(self):
        data = {
            "username": self.user.get("login"),
            "followers": self.user.get("followers"),
            "following": self.user.get("following"),
            "public_repos": self.user.get("public_repos"),
            "total_stars": self._get_total_stars(),
            "most_used_language": self._get_most_used_language(),
            "top_repos": self._get_top_repos()
        }

        return data

    def display_data(self, data):
        print("\n===== Github Profile  =====\n")
        print(f"Username: {data['username']}")
        print(f"Followers: {data['followers']}")
        print(f"Following: {data['following']}")
        print(f"Public Repos: {data['public_repos']}")

        print("\n===== Repository analysis =====\n")
        print(f"Total repositories: {data['public_repos']}")
        print(f"Total stars: {data['total_stars']}\n")
        print(f"Most used language: {data['most_used_language']}")

        print("\nTop 2 repositories:")

        for index, repo in enumerate(data['top_repos'], start=1):
            print(f"\t{index}. {repo['name']}")
            print(f"\t{repo['language']}")
            print(f"\t{repo['stars']}\n")




