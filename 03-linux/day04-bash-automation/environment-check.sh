#!/usr/bin/env bash

print_header() {
	echo "=== Development Environment Check==="
}

show_basic_information() {
	local current_user
	local current_directory

	current_user=$(whoami)
	current_directory=$(pwd)

	echo "Current user: $current_user"
	echo "Current directory: $current_directory"
}

check_command() {
	local command_name="$1"

	if command -v "$command_name" > /dev/null 2>&1; then
		echo "[OK] $command_name is installed"
		return 0
	else
		echo "[MISSING] $command_name is not installed"
		return 1
	fi
}

check_python() {
	if check_command python3; then
		echo "Python version: $(python3 --version 2>&1)"
	fi
}

check_git() {
	if check_command git; then
		echo "Git version: $(git --version)"
	fi
}

check_virtual_environment() {
	if [ -n "${VIRTUAL_ENV:-}" ]; then
		echo "[OK] Virtual environment is active"
		echo "Virtual environment path: $VIRTUAL_ENV"
	else
		echo "[INFO] No virtual environment is active."
	fi
}

check_project_file() {
	local file_name="$1"

	if [ -f "$file_name" ]; then
	 	echo "[OK] Project file exists: $file_name"
	else
		echo "[MISSING] Project file is missing: $file_name"
	fi
}

main() {
	print_header
	show_basic_information
	check_python
	check_git
	check_virtual_environment

	echo "=== Project Files ==="
	check_project_file "hello.sh"
   	check_project_file "variables.sh"
    	check_project_file "quotes.sh"
  	check_project_file "arguments.sh"
    	check_project_file "while-counter.sh"
    	check_project_file "functions.sh"
    	check_project_file "environment-check.sh"
}

main "$@"
