import requests


def main() -> None:
    print(f"requests version: {requests.__version__}")

    try:
        response = requests.get("https://example.com", timeout=10)
        print(f"HTTP status code: {response.status_code}")
    except requests.RequestException as error:
        print(f"Request failed: {error}")


if __name__ == "__main__":
    main()
