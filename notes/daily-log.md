# Python Learning Log

## 2026-07-04

### Goal
Complete Python Day 1: Word Count practice.

### Done
- Built a basic word count program.
- Learned basic Python syntax:
  - input(), print()
  - list, dict
  - for loop, if-else
  - split(), len()
- Learned dictionary-based word frequency counting.
- Learned basic sorting with sorted() and lambda.
- Practiced string processing with lower() and replace().

### Problems
- Initially confused about sorted(), key, and lambda.
- Needed more understanding of dictionaries and loops.

### Reflection
Learned that Python programs are built by combining basic data structures and control flow. Started focusing on understanding logic instead of copying code.

---

## 2026-07-05

### Goal
Complete score analysis practice and learn function-based code organization.

### Done
- Built a student score analysis program.
- Used:
  - dict to store student scores
  - float() for numeric input
  - sum(), max(), min()
  - try/except for invalid input
  - continue for input validation
- Learned Python functions:
  - def
  - parameters
  - return
  - function calls
- Added main() and:
  - if __name__ == "__main__"
- Learned to separate calculation logic and display logic.
- Refactored the previous word count program using functions.

### Problems
- Confused about the difference between defining and calling functions.
- Needed to understand why main() and __name__ == "__main__" are useful.

### Reflection
Started to understand that programming is not only about making programs run, but also about improving code structure and readability.

---

## 2026-07-06

### Goal
Complete file processing practice and build a text analysis tool.

### Done
- Learned file operations:
  - open()
  - with open()
  - read/write modes
  - file encoding
- Learned JSON processing:
  - json.dump()
  - converting Python dictionaries to JSON
- Learned exception handling:
  - try/except
  - FileNotFoundError
- Understood relative paths and CWD.
- Built a Text Analyzer tool:

Input:
- English text file

Process:
- Clean text
- Count word frequency
- Calculate statistics
- Find top words

Output:
- JSON report file

### Problems
- Needed clarification about:
  - file objects
  - encoding
  - JSON format
  - working directory

### Reflection
Learned that real programs need to interact with external data. File processing and JSON are important foundations for future AI applications.

### Next
Upgrade the project with CLI and engineering structure.

## 2026-07-07

### Goal
Complete Python Day 4: learn modules, project structure, virtual environments, and dependency management.

### Minimum Success
- Understand Python modules and imports.
- Split the Text Analyzer project into multiple files.
- Understand the basic usage of virtual environments.

### Done
- Learned the difference between modules and packages.
- Learned how `import` and `from ... import ...` work.
- Practiced importing functions from another Python file.
- Understood why `from xxx import *` is not recommended in real projects.
- Learned how Python finds imported modules.

- Refactored the Text Analyzer project into a modular structure:

text_analyzer/

├── main.py
├── analyzer.py
├── file_utils.py
├── display.py
├── input.txt
└── report.json

- Separated different responsibilities:
  - `analyzer.py`: text processing and analysis logic.
  - `file_utils.py`: file reading and writing.
  - `display.py`: result display.
  - `main.py`: program workflow control.

- Successfully tested the modular project.

- Learned the concept of virtual environments.
- Understood the relationship between:
  - Python interpreter (`python.exe`)
  - Virtual environment (`.venv`)
  - Package installation (`pip`)
  - Dependency management (`requirements.txt`)

- Learned the structure of a virtual environment:

.venv/

├── Scripts
├── Lib
├── Include
└── pyvenv.cfg

- Understood:
  - `Scripts/python.exe` is the Python interpreter used by the virtual environment.
  - `Scripts/pip.exe` installs packages into the current environment.
  - `Lib/site-packages` stores installed Python packages.
  - `pyvenv.cfg` stores virtual environment configuration.

### Key Concepts
- Module: a single `.py` file.
- Package: a folder containing multiple modules.
- `import module` imports a module or package.
- `from module import function` imports specific objects.
- Virtual environments isolate project dependencies.
- `requirements.txt` records project dependencies.

### Problems
- I was confused about the difference between modules, packages, and libraries.
- I needed more explanation about why `import *` is not recommended.
- I needed to understand where exceptions should be handled in a project.
- I was confused about the relationship between `python.exe`, Python installation, and virtual environments.

### Reflection
Today I moved from writing single Python scripts to understanding basic project organization. I learned that real software development requires not only working code, but also clear structure, dependency management, and isolated environments.

### Tomorrow
- Start Python Day 5: HTTP requests and API usage.
- Learn:
  - HTTP basics
  - GET / POST
  - `requests` library
  - JSON response parsing

- Build a small API-based command-line tool.

## 2026-07-08

### Goal
Complete Python Day 5: learn HTTP requests and API usage.

### Minimum Success
- Understand basic HTTP concepts.
- Use Python to send GET and POST requests.
- Parse JSON responses.

### Done
- Learned the basic concepts of HTTP:
  - Request
  - Response
  - Client and Server

- Learned how to use the `requests` library.
- Learned how to send GET requests with `requests.get()`.
- Learned how to use `Response` objects:
  - `status_code`
  - `text`
  - `json()`

- Learned how to convert JSON responses into Python dictionaries.

- Completed a GitHub API practice:
  - Input GitHub username.
  - Send API request.
  - Check response status.
  - Extract user information from JSON.

- Learned the difference between GET and POST:
  - GET is mainly used to retrieve data.
  - POST is used to send data to the server.

- Completed a POST request practice using JSON data.

- Learned API parameters:
  - Path parameters.
  - Query parameters.

- Learned basic API error handling using `try / except`.

- Refactored API code into modules:
  - `main.py`: program flow and user interaction.
  - `github_api.py`: GitHub API request logic.

### Key Concepts
- API allows programs to communicate with external services.
- `requests.get()` sends GET requests.
- `requests.post()` sends POST requests.
- `response.json()` converts JSON data into Python dictionaries.
- API development usually follows:
  - Send request
  - Receive response
  - Parse JSON
  - Process data

### Problems
- I needed to understand the difference between JSON data and Python dictionaries.
- I was confused about the structure of API URLs and why some use `api.xxx.com`.
- I needed more understanding of GET parameters and POST data.
- I needed to understand why API code should be separated into modules.

### Reflection
Today I moved from local Python programs to programs that can communicate with external services. I learned the basic workflow behind modern applications and AI API calls.

### Tomorrow
- Start Python Day 6: Object-Oriented Programming (OOP).
- Learn:
  - Class
  - Object
  - Attribute
  - Method
  - `__init__`
  - `self`

- Refactor previous API tools using classes.


## 2026-07-09

### Goal
Complete Python Day 6 object-oriented programming practice.

### Minimum Success
- Understand Python classes and objects.
- Build a simple API client using OOP.

### Done
- Learned the relationship between classes and objects.
- Learned `__init__()` and how it initializes object attributes.
- Learned `self` and understood that Python automatically passes the current object.
- Learned instance attributes and class attributes.
- Learned how `__str__()` controls object display.
- Refactored the GitHub API tool from functions into a `GitHubClient` class.
- Split the project into multiple files:
  - `github_client.py` for API client logic.
  - `main.py` for program execution.
- Learned module importing and how different files work together.
- Added internal methods using `_` naming conventions.
- Used `_get()` to reduce duplicated request code.
- Added request timeout handling.
- Learned `raise_for_status()` for handling HTTP errors.
- Created a custom exception `GitHubAPIError`.
- Learned how to use `raise` to pass errors to higher-level code.
- Learned exception propagation and how `try / except` catches custom exceptions.
- Learned exception chaining with `raise ... from error`.

### Key Concepts
- A class is a template for creating objects.
- Objects contain their own attributes and methods.
- `self` represents the current object.
- Instance attributes belong to individual objects.
- Class attributes are shared by all objects.
- Encapsulation means hiding internal implementation details.
- Lower-level modules should raise errors, while higher-level programs handle and display errors.
- `raise` sends an exception outward.
- `try / except` receives and handles exceptions.

### Problems
- Initially confused why `self` needs to be written explicitly compared with C++ `this`.
- Needed to understand why objects can dynamically add attributes.
- Confused about the difference between `is` and `==` when checking `None`.
- Needed more explanation about `raise`, exception propagation, and exception chains.
- Needed to understand why `raise ... from error` does not change normal `print(error)` output.

### Reflection
Today I moved from writing simple Python scripts to designing a small structured application. I learned that real projects are not only about making code run, but also about organizing code, separating responsibilities, and handling errors properly. Building the GitHub API client helped me understand how real SDKs are designed.

### Tomorrow
- Learn API authentication.
- Understand HTTP headers and API keys.
- Learn environment variables and `.env` files.
- Prepare for calling LLM APIs in future AI application projects.


## 2026-07-10

### Goal
Complete Python Day 7: learn API keys, headers, environment variables, and safe configuration management.

### Minimum Success
- Understand what API keys and tokens are.
- Understand how HTTP headers carry authentication information.
- Learn how to store secrets safely using `.env`.
- Use Python to load environment variables and pass a token into an API client.

### Done
- Created `day07-api-key-headers`.
- Reviewed the difference between API keys, access tokens, and AI model tokens.
- Learned why API keys should not be written directly in Python code.
- Learned common HTTP headers:
  - `Accept`
  - `Content-Type`
  - `Authorization`
- Learned the meaning of `Authorization: Bearer <token>`.
- Updated `GitHubClient` to support an optional token.
- Added `_get_headers()` to generate request headers.
- Used `headers=self._get_headers()` in `requests.get()`.
- Learned why empty tokens can cause `401 Unauthorized`.
- Changed token checking from `is not None` to truth-value checking with `if self.token`.
- Learned common false values in Python:
  - `None`
  - `False`
  - `0`
  - `""`
  - `[]`
  - `{}`
- Created a `.env` file to store local environment variables.
- Added `.env` to `.gitignore` to avoid leaking secrets.
- Installed and used `python-dotenv`.
- Learned `load_dotenv()` and `os.getenv()`.
- Used `Path(__file__).resolve().parents[2]` to locate the project root.
- Loaded `GITHUB_TOKEN` safely from `.env`.
- Added a safe token status message without printing the actual token.
- Improved GitHub repository output by extracting:
  - repository name
  - stars
  - language
  - last updated time
- Learned `dict.get()` for safer dictionary access.
- Learned why `repo.get("language") or "Unknown"` handles `None` values better.

### Key Concepts
- API keys and tokens are credentials used to authenticate API requests.
- Headers carry metadata such as authentication and data format.
- `Authorization: Bearer <token>` is a common API authentication format.
- `.env` stores local configuration and secrets outside source code.
- `load_dotenv()` loads `.env` values into the current Python process.
- `os.getenv()` reads values from environment variables.
- `.env` should never be uploaded to GitHub.
- `Path` provides a safer way to work with file paths.
- `.get()` avoids `KeyError` when reading dictionaries.
- `A or B` returns `B` when `A` is a false value.

### Problems
- I was confused about why API authentication tokens and AI usage tokens both use the word “token”.
- I needed to understand why headers must follow API documentation.
- I encountered GitHub API rate limits when using unauthenticated requests.
- I encountered `401 Unauthorized` because an empty token was still being sent.
- I needed to understand the difference between `if token`, `if token is not None`, and false values in Python.
- I needed to understand where `.env` is loaded from and whether it affects the whole computer.

### Reflection
Today I learned how real projects manage sensitive configuration. I understood that API development is not only about sending requests, but also about authentication, security, environment variables, and safe project structure. This is an important step toward using real AI APIs later.

### Tomorrow
- Start Day 8: GitHub Profile Analyzer.
- Build a small integrated project using:
  - OOP
  - API requests
  - headers
  - `.env`
  - JSON data parsing
  - exception handling
  - file writing

- Generate a structured GitHub profile report and save it as JSON.


## 2026-07-11 — Day 8: GitHub Profile Analyzer

### Goal
Build a Python CLI tool to fetch GitHub profile data, analyze repositories, and save results as JSON.

### Done
- Fixed GitHub API endpoint:
  - `/user/{username}` → `/users/{username}`
- Fetched user profile and repository data
- Used GitHub token authentication
- Added custom API error handling
- Split the project into modules
- Calculated total stars
- Found the most used language
- Sorted repositories by stars
- Selected the top 2 repositories
- Saved results with `json.dump()`
- Added formatted console output
- Used `enumerate(..., start=1)` for ranking
- Handled missing language data with `"Unknown"`
- Avoided repeated calls to `get_data()`

### Learned
- `json.dump()` writes Python data to a JSON file
- `.get()` safely reads dictionary values
- `max(dictionary, key=dictionary.get)` finds the key with the largest value
- `sorted()` uses ascending order by default
- `reverse=True` sorts in descending order
- `append()` adds one item to a list
- `[:2]` returns the first two items
- `enumerate()` provides both index and item

### Problem
A 404 error occurred because the API path used `/user/octocat` instead of `/users/octocat`.

### Reflection
I completed my first structured Python API analysis project with requests, authentication, exceptions, data analysis, JSON output, and modular design.

### Tomorrow
Start Git basics:
- `git init`
- `git status`
- `git add`
- `git commit`
- `git diff`
- `git log`
- `.gitignore`
## 2026-07-12 — Git and GitHub Basics

### Goal
Complete Git and GitHub basic workflow practice using PyCharm.

### Minimum Success
- Understand the relationship between the working directory, staging area, local repository, and remote repository.
- Complete the basic workflow of commit, push, pull, branch, merge, and pull request.
- Learn how to use Git mainly through PyCharm visual tools.

### Done
- Initialized the project as a Git repository.
- Created a root-level `.gitignore`.
- Ignored local and sensitive files:
  - `.env`
  - `.venv/`
  - `.idea/`
  - `__pycache__/`
  - `*.pyc`
  - `report.json`
- Completed the first local commit.
- Published the project to GitHub.
- Learned the difference between:
  - `Commit`
  - `Push`
  - `Pull`
  - `Fetch`
- Renamed the main branch from `master` to `main`.
- Learned that Git tracks files rather than empty folders.
- Learned how to view changed files and compare differences in PyCharm.
- Practiced restoring uncommitted changes.
- Practiced creating and switching branches.
- Created the branch:
  - `practice/git-branch`
- Added Git learning notes on the practice branch.
- Merged the practice branch into `main`.
- Practiced resolving a merge conflict.
- Learned how local `main` and remote `origin/main` are synchronized.
- Modified a file directly on GitHub and pulled the remote change into PyCharm.
- Created the feature branch:
  - `feature/add-git-workflow-notes`
- Pushed the feature branch to GitHub.
- Created a pull request.
- Reviewed the changed files in the pull request.
- Merged the pull request into `main`.
- Deleted the completed feature branch.
- Pulled the updated remote `main` branch back to the local repository.

### Key Concepts
- The working directory contains current file changes.
- The staging area contains changes selected for the next commit.
- A commit saves a project version in the local Git repository.
- Push uploads local commits to GitHub.
- Pull downloads and integrates remote changes.
- Fetch updates remote repository information without immediately merging it.
- A branch is an independent development line.
- Merge combines changes from one branch into another.
- A merge conflict occurs when Git cannot automatically combine different changes.
- A pull request is a request to review and merge one branch into another.
- `main` usually stores the stable version of a project.
- `origin` is the conventional name of the main remote repository.
- `origin/main` represents the remote-tracking version of the GitHub `main` branch.
- Git tracks files, not empty directories.
- PyCharm Git operations still use Git internally.

### Problems
- I was confused about the meaning of the remote name `origin`.
- I needed to understand why the local branch was renamed to `main` while the remote branch was still `master`.
- I was confused about the relationship between local branches and remote branches.
- I needed to understand why the entire `02-git-github` folder disappeared after switching branches.
- I was unsure whether PyCharm visual Git operations could replace command-line operations.
- I needed to understand the difference between local merge and GitHub pull request merge.
- I needed more explanation about `Push`, `Pull`, and `Fetch`.

### Reflection
Today I completed my first full Git and GitHub workflow. I learned that Git is not only used to upload code, but also to record project history, isolate development with branches, merge changes, resolve conflicts, and collaborate through pull requests. I also learned that PyCharm visual tools can handle most daily Git operations, while understanding the corresponding Git concepts is still important for troubleshooting and remote development.

### Tomorrow
- Start GitHub repository and profile optimization.
- Improve the root `README.md`.
- Learn how to write a clear project introduction.
- Add:
  - project overview
  - learning roadmap
  - repository structure
  - completed projects
  - technology stack
- Learn basic GitHub features:
  - Issues
  - Fork
  - Star
  - Tags
  - Releases


## 2026-07-13 — GitHub Profile and Project Management

### Goal
Build a clear GitHub developer profile and learn how GitHub features can be used to present projects and manage future work.

### Minimum Success
- Create a GitHub Profile README.
- Improve the public presentation of my repositories.
- Create and manage a real GitHub Issue.
- Publish the first Tag and Release.
- Create a GitHub Projects roadmap.

### Done
- Created the special `zhantianbao91/zhantianbao91` repository.
- Built the first version of my GitHub Profile README.
- Added a clear personal introduction.
- Described my current learning focus and career direction.
- Added the GitHub Profile Analyzer as a featured project.
- Added my learning roadmap and technology stack.
- Added the `International-AI-Engineer` repository to my pinned repositories.
- Added repository descriptions and Topics.
- Learned the purpose of the main GitHub repository sections:
  - Code
  - Issues
  - Pull requests
  - Agents
  - Actions
  - Projects
  - Wiki
  - Security and quality
  - Insights
  - Settings
- Learned the difference between:
  - Repository Description
  - Profile README
  - Repository README
- Created the Issue:
  - `Improve GitHub profile portfolio`
- Assigned the Issue to myself.
- Used a task checklist to record progress.
- Added the real Issue to a GitHub Project.
- Created the GitHub Project:
  - `International AI Engineer Roadmap`
- Used the following Project statuses:
  - Todo
  - In Progress
  - Done
- Added completed and future learning stages to the Project.
- Learned the difference between a Draft issue and a Repository issue.
- Created the first Git Tag:
  - `v0.1.0`
- Published the first GitHub Release:
  - `Python Foundation and GitHub Basics Completed`
- Learned the relationship between:
  - Commit
  - Branch
  - Tag
  - Release
- Learned the purpose of:
  - Releases
  - Deployments
  - Packages
- Learned what `.tar.gz` means and how it differs from `.zip`.

### Key Concepts
- A GitHub Profile README introduces the developer rather than a single project.
- A repository Description is a short public summary shown before visitors open the README.
- Topics help visitors and GitHub understand the subject of a repository.
- Pinned repositories highlight the most important work on a profile.
- An Issue is a formal task, problem, or improvement request associated with a repository.
- A Draft issue is a lightweight task that exists only inside a GitHub Project.
- A GitHub Project organizes Issues, Pull Requests, and Draft issues using tables, boards, or roadmaps.
- A Tag permanently marks a specific Commit.
- A Release adds a public version page, release notes, and downloadable source archives around a Tag.
- A Deployment represents a version of an application running in an environment.
- A Package is an installable artifact such as a Python package or Docker image.
- `.tar` archives multiple files, while `gzip` compresses the archive.
- `.tar.gz` therefore means a tar archive compressed with gzip.

### Problems
- I needed to understand the purpose of each major GitHub repository tab.
- I was unsure whether repository descriptions were public.
- I needed to distinguish Releases, Deployments, and Packages.
- I was confused about the relationship between Tags and Releases.
- I needed to understand the purpose of `.tar.gz` source archives.
- Adding too many detailed tasks made the Project board difficult to manage.
- I needed to distinguish roadmap-level tasks from detailed Issue checklists.
- I needed to understand the difference between Draft issues and real repository Issues.

### Reflection
Today I changed my GitHub account from a simple code storage space into the beginning of a developer portfolio. I learned that a strong GitHub profile should clearly present my identity, direction, current projects, and learning progress. I also learned how Issues and Projects can be used to organize work, while Tags and Releases can mark important project milestones. I should continue keeping the information accurate and only claim technologies that I have genuinely used.

### Tomorrow
- Complete the remaining GitHub profile improvements.
- Close or update the current profile Issue when appropriate.
- Begin `03-linux`.
- Learn the Linux terminal and command structure.
- Practice paths, files, and directory operations.
- Understand why Linux is widely used for backend and AI deployment.