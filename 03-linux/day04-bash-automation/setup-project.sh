#!/usr/bin/env bash

venv_directory=".venv"
requirements_file="requirements.txt"

echo "=== Project Setup ==="

if [ -d "$venv_directory" ]; then
	echo "[INFO] Virtual environment already exists: $venv_directory"
else
	echo "[INFO] Creating virtual enviroment..."

	if python3 -m venv "$venv_directory"; then
		echo "[OK] Virtual environment created."
	else
		echo "[ERROR] Failed to create virtual environment."
		exit 1
	fi
fi

if [ -f "$requirements_file" ]; then
	echo "[OK] Requirements file found: $requirements_file"
else
	echo "[ERROR] Requirements file is missing: $requirements_file"
	exit 1
fi

echo "[INFO] Installing dependecies"

if "$venv_directory/bin/python" -m pip install -r "$requirements_file"; then
	echo "[OK] Dependencies installed"
else
	echo "[ERROR] Dependency installation failed."
	exit 1
fi

echo "[INFO] Verifying installation..."

if "$venv_directory/bin/python" -c "import requests"; then
	requests_version=$("$venv_directory/bin/python" -c "import requests; print(requests.__version__)")
	echo "[OK] requests $requests_version is installed"
else
	echo "[ERROR] requests could not be imported."
fi

echo "=== Project Setup Completed ==="
