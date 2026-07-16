# Linux Day03: Python Environment

## System Python

* Python version: 3.10.12
* System interpreter: `/usr/bin/python3`
* System pip module: `/usr/lib/python3/dist-packages/pip`

## Virtual Environment

Create a virtual environment:

```bash
python3 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

Deactivate it:

```bash
deactivate
```

Activating a virtual environment places `.venv/bin` at the beginning of `PATH`.

## Package Management

Install a package inside the virtual environment:

```bash
python -m pip install requests
```

Generate the dependency file:

```bash
python -m pip freeze > requirements.txt
```

Restore the environment:

```bash
python -m pip install -r requirements.txt
```

## Key Conclusions

* A virtual environment isolates Python packages for one project.
* `.venv` can be deleted and recreated.
* `requirements.txt` records the required package versions.
* `.venv/` should be ignored by Git.
* Inside an activated environment, use `python -m pip` to ensure Python and pip match.
