# GitHub Profile Analyzer

A Python command-line tool that fetches GitHub user and repository data,
analyzes repository statistics, and generates a JSON report.

## Features

- Fetch GitHub user information
- Fetch public repositories
- Calculate total stars
- Find the most used programming language
- Display top repositories by stars
- Save analysis results to JSON
- Handle GitHub API request errors

## Project Structure

```text
day08-github-profile-analyzer/
├── main.py
├── github_client.py
├── github_request_error.py
├── analyzer.py
└── file_utils.py