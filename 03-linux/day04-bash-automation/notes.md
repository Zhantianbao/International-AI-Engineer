# Linux Day04 - Bash Scripting and Automation

## 1. What Bash Is

Bash stands for **Bourne Again Shell**.

Bash has two main roles:

1. A command interpreter that reads, parses, and executes shell commands.
2. An automation tool that combines commands into repeatable workflows.

Shell scripting is useful for:

- Automating repetitive commands
- Processing multiple files
- Checking development environments
- Creating virtual environments
- Installing dependencies
- Running tests and applications
- Managing and deploying Linux servers

## 2. Bash as a Command Interpreter

A command interpreter reads commands entered by the user or stored in a script.

For example:

```bash
echo "Current user: $USER"
```

Bash performs the following work:

1. Reads the command.
2. Identifies `echo` as the command.
3. Expands `$USER`.
4. Passes the final argument to `echo`.
5. Executes the command.
6. Receives the exit status.

Bash can interpret:

- Variables
- Quotes
- Command substitution
- Redirection
- Pipes
- Conditions
- Loops
- Functions

Bash may execute:

- Shell built-in commands
- Shell functions
- External programs found through `PATH`

Examples:

```bash
type cd
type echo
type ls
```

`cd` is normally a Bash built-in command.

`ls` is normally an external program such as:

```text
/usr/bin/ls
```

## 3. Bash as an Automation Tool

Bash can combine multiple commands into one repeatable workflow.

A script can:

- Check required commands
- Check files and directories
- Create resources
- Install dependencies
- Run tests
- Start an application
- Stop when an error occurs

Example workflow:

```text
Check prerequisites
-> Create virtual environment
-> Install dependencies
-> Verify installation
-> Start application
```

Bash is often called a glue language because it connects different commands and programs.

## 4. Basic Bash Script

A Bash script commonly begins with:

```bash
#!/usr/bin/env bash
```

This line is called the shebang.

The shebang tells the operating system which interpreter should execute the file.

Another common form is:

```bash
#!/bin/bash
```

The difference is:

```text
#!/bin/bash
Uses Bash from the fixed path /bin/bash.

#!/usr/bin/env bash
Uses env to find Bash through PATH.
```

## 5. Running a Bash Script

A script can be run with:

```bash
bash script.sh
```

This explicitly starts Bash and asks Bash to read the file.

A script can also be executed directly:

```bash
./script.sh
```

Direct execution requires:

- Execution permission
- A valid shebang

Execution permission can be added with:

```bash
chmod u+x script.sh
```

Difference:

```text
bash script.sh
- Does not require execution permission
- Uses the Bash command explicitly
- Does not depend on the script shebang

./script.sh
- Requires execution permission
- Uses the interpreter specified by the shebang
- Treats the file as an executable program
```

## 6. Bash Variables

Variable assignment uses this format:

```bash
name="skybaby"
```

Important rules:

- Do not put spaces around `=`.
- Do not use `$` on the left side of an assignment.
- Variable names may contain letters, numbers, and underscores.
- Variable names cannot begin with a number.
- Bash variable names are case-sensitive.
- Values containing spaces should be quoted.

Correct:

```bash
name="skybaby"
project_name="AI Application Development"
count=3
```

Incorrect:

```bash
name = "skybaby"
$name="skybaby"
project-name="demo"
3name="demo"
```

To read a variable:

```bash
echo "$name"
```

Use:

```bash
"$variable"
```

to protect the value from unwanted word splitting.

## 7. Variable Expansion

Variable expansion means replacing a variable reference with its value.

Example:

```bash
name="skybaby"
echo "Hello, $name"
```

Bash changes:

```text
Hello, $name
```

into:

```text
Hello, skybaby
```

Braces can make the variable boundary clear:

```bash
name="sky"
echo "${name}baby"
```

Output:

```text
skybaby
```

Assignment and expansion are different:

```text
name="value"    writes a value
"$name"         reads a value
```

## 8. Single Quotes and Double Quotes

Single quotes preserve content literally:

```bash
name="skybaby"
echo '$name'
```

Output:

```text
$name
```

Inside single quotes:

- Variables are not expanded
- Commands are not executed
- Arithmetic is not expanded
- Most characters remain literal

Double quotes protect the text as one argument but still allow expansion:

```bash
name="skybaby"
echo "Hello, $name"
echo "Directory: $(pwd)"
```

Summary:

```text
'...'
- Preserves content literally
- Does not expand variables
- Does not perform command substitution

"..."
- Preserves spaces
- Expands variables
- Performs command substitution
- Performs arithmetic expansion
```

To display a literal dollar sign inside double quotes:

```bash
echo "\$name"
```

Output:

```text
$name
```

## 9. Command Substitution

Command substitution uses:

```bash
$(command)
```

It means:

1. Execute the command.
2. Capture its standard output.
3. Replace `$(command)` with that output.

Example:

```bash
current_directory="$(pwd)"
```

Execution process:

```text
Execute pwd
-> Capture its output
-> Replace $(pwd)
-> Assign the result to current_directory
```

Another example:

```bash
today="$(date +%F)"
```

Command substitution normally captures standard output.

It removes trailing newline characters from the captured output.

Modern Bash code should prefer:

```bash
$(command)
```

instead of the older backtick form.

## 10. Exit Status

Every command returns an exit status.

General convention:

```text
0          success
non-zero   failure or another special condition
```

The special parameter:

```bash
$?
```

stores the exit status of the most recently executed command.

Example:

```bash
ls quotes.sh
echo "$?"
```

If the file exists, the result is normally:

```text
0
```

Example with failure:

```bash
ls file-does-not-exist
echo "$?"
```

The result may be:

```text
2
```

The value must be checked immediately because every new command updates `$?`.

To save it:

```bash
status="$?"
```

## 11. Conditional Command Execution

The operator:

```bash
command1 && command2
```

means:

```text
Run command2 only if command1 succeeds.
```

The operator:

```bash
command1 || command2
```

means:

```text
Run command2 only if command1 fails.
```

Examples:

```bash
ls quotes.sh && echo "File exists"
ls missing-file || echo "File is missing"
```

## 12. Script Arguments

Bash scripts can receive command-line arguments.

Example:

```bash
./arguments.sh apple banana
```

Special positional parameters:

```text
$0    script name
$1    first argument
$2    second argument
$3    third argument
$#    number of arguments
$@    all arguments
```

Example:

```bash
echo "Script name: $0"
echo "First argument: $1"
echo "Argument count: $#"
```

Use:

```bash
"$@"
```

to preserve the boundary of every argument.

Example:

```bash
./arguments.sh "AI APP" Linux
```

With `"$@"`, Bash preserves two arguments:

```text
AI APP
Linux
```

## 13. Conditional Statements

Basic structure:

```bash
if command; then
    echo "Success"
elif another_command; then
    echo "Alternative condition succeeded"
else
    echo "Failure"
fi
```

Keywords:

```text
if      if
then    execute this when the condition succeeds
elif    else if
else    execute this when previous conditions fail
fi      end of the if structure
```

Bash `if` checks the exit status of a command.

It does not require a Boolean expression.

Example:

```bash
if command -v python3; then
    echo "Python is available"
fi
```

## 14. The Test Command

These two forms are equivalent:

```bash
[ -f "$file_name" ]
```

```bash
test -f "$file_name"
```

The `[` form requires spaces:

```bash
[ -f "$file_name" ]
```

Incorrect:

```bash
[-f "$file_name"]
if[ -f "$file_name" ]; then
```

Common test operators:

```text
-e    path exists
-f    path is a regular file
-d    path is a directory
-r    path is readable
-w    path is writable
-x    path is executable
-s    file exists and is not empty
-n    string is not empty
-z    string is empty
```

Numeric comparison operators:

```text
-eq   equal
-ne   not equal
-gt   greater than
-lt   less than
-ge   greater than or equal
-le   less than or equal
```

Example:

```bash
if [ "$#" -eq 0 ]; then
    echo "No arguments were provided"
fi
```

## 15. File and Directory Checks

Check whether a regular file exists:

```bash
if [ -f "$file_name" ]; then
    echo "Regular file exists"
fi
```

Check whether a directory exists:

```bash
if [ -d ".venv" ]; then
    echo "Directory exists"
fi
```

Check whether any path exists:

```bash
if [ -e "$path" ]; then
    echo "Path exists"
fi
```

Difference:

```text
-e    checks whether a path exists
-f    checks whether it is a regular file
-d    checks whether it is a directory
```

## 16. Safe Parameter Expansion

Example:

```bash
"${VIRTUAL_ENV:-}"
```

General form:

```bash
${variable:-default_value}
```

Meaning:

```text
If the variable is defined and not empty:
    use its value

If the variable is undefined or empty:
    use the default value
```

In:

```bash
"${VIRTUAL_ENV:-}"
```

the default value is an empty string.

This allows safe checking:

```bash
if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "Virtual environment is active"
fi
```

Here:

```text
-n
checks whether the final string is not empty
```

The colon in `:-` means both undefined and empty values use the default.

The minus sign means use a temporary default value without assigning it to the variable.

## 17. Checking Whether a Command Exists

Recommended form:

```bash
command -v python3
```

In a script:

```bash
if command -v python3 > /dev/null 2>&1; then
    echo "[OK] python3 is installed"
else
    echo "[MISSING] python3 is not installed"
fi
```

`command -v` checks whether the current Shell can resolve and execute a command.

It can identify:

- External programs
- Bash built-in commands
- Shell functions
- Aliases

The redirection:

```bash
> /dev/null 2>&1
```

means:

```text
> /dev/null
Send standard output to /dev/null.

2>&1
Send standard error to the same destination as standard output.
```

The script ignores output and only uses the exit status.

## 18. For Loops

Basic structure:

```bash
for item in "$@"; do
    echo "$item"
done
```

Keywords:

```text
for     start a loop
in      specify the collection
do      begin the loop body
done    end the loop
```

Example:

```bash
for command_name in "$@"; do
    command -v "$command_name"
done
```

A `for` loop is useful when processing:

- Multiple arguments
- Multiple files
- Multiple commands
- Multiple directories

## 19. While Loops

Basic structure:

```bash
count=1

while [ "$count" -le 3 ]; do
    echo "Current count: $count"
    count=$((count + 1))
done
```

A `while` loop continues while its condition succeeds.

The line:

```bash
count=$((count + 1))
```

performs integer arithmetic and increases `count` by one.

Without updating `count`, the loop may become an infinite loop.

An infinite loop can usually be stopped with:

```text
Ctrl + C
```

## 20. Bash Functions

Function definition:

```bash
greet() {
    local name="$1"
    echo "Hello, $name"
}
```

Function call:

```bash
greet "skybaby"
```

A function is a named group of commands.

Functions improve script organization by providing:

- Code reuse
- Better readability
- Clearer main workflows
- Easier maintenance
- Easier testing
- Less repeated code
- Reduced variable interference with `local`

Function parameters:

```text
$1    first function argument
$2    second function argument
$#    number of function arguments
$@    all function arguments
```

During a function call, these values refer to the function arguments.

## 21. Local Variables

Example:

```bash
check_command() {
    local command_name="$1"
}
```

`local` creates a variable for the current function call.

It helps prevent a function from changing an outer variable with the same name.

Without `local`, function assignments may modify variables outside the function.

## 22. Function Exit Status

A Bash function returns an exit status.

Example:

```bash
check_command() {
    if command -v "$1" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}
```

Meaning:

```text
return 0    success
return 1    failure
```

If a function does not explicitly use `return`, its status is normally the status of the last command executed inside it.

In Bash:

```text
echo or printf
is used to output data.

return
is mainly used to return a success or failure status.
```

## 23. Main Function

A larger Bash script may use:

```bash
main() {
    check_python
    check_git
    check_virtual_environment
}

main "$@"
```

The `main` function makes the main workflow easier to read.

The last line:

```bash
main "$@"
```

starts the program and passes all script arguments to `main`.

## 24. Environment Checking Script

The environment checking script verifies:

- Current user
- Current directory
- Python installation
- Python version
- Git installation
- Git version
- Virtual environment status
- Required project files

Current user:

```bash
whoami
```

Current directory:

```bash
pwd
```

Python version:

```bash
python3 --version
```

Git version:

```bash
git --version
```

Virtual environment status:

```bash
if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "Virtual environment is active"
fi
```

Project file check:

```bash
if [ -f "$file_name" ]; then
    echo "Project file exists"
fi
```

## 25. Project Setup Script

The setup script performs these steps:

1. Check whether `.venv` exists.
2. Create `.venv` if necessary.
3. Check whether `requirements.txt` exists.
4. Install dependencies.
5. Verify that a dependency can be imported.
6. Print the installed dependency version.

Create a virtual environment:

```bash
python3 -m venv .venv
```

Here:

```text
python3    starts the Python 3 interpreter
-m         runs a Python module
venv       is the virtual environment module
.venv      is the destination directory
```

Install dependencies:

```bash
.venv/bin/python -m pip install -r requirements.txt
```

Using `.venv/bin/python` guarantees that pip installs packages into the correct virtual environment.

Verify installation:

```bash
.venv/bin/python -c "import requests"
```

The `-c` option tells Python to execute the provided Python code directly.

Print the package version:

```bash
.venv/bin/python -c "import requests; print(requests.__version__)"
```

## 26. Bash Syntax Checking

Before executing a script, check its syntax with:

```bash
bash -n script.sh
```

The `-n` option tells Bash to read and validate the script without executing commands.

After the check:

```bash
echo "$?"
```

A result of `0` means no syntax error was detected.

Note:

```text
bash -n script.sh
and
[ -n "$value" ]
use the same characters, but they are different options in different commands.
```

## 27. Common Errors

### Unmatched Quotation Marks

Error:

```text
unexpected EOF while looking for matching `"'
```

Meaning:

```text
Bash reached the end of the file while still looking for a closing double quote.
```

### Missing Spaces

Correct:

```bash
if [ -f "$file_name" ]; then
```

Incorrect:

```bash
if[ -f "$file_name" ]; then
```

### Confusing Two Forms

Command substitution:

```bash
$(command)
```

Parameter expansion:

```bash
${variable}
${variable:-default}
```

### Misspelled Variables

These are different variables:

```bash
target_file
targer_file
```

An undefined variable normally expands to an empty string unless strict Shell options are enabled.

### Misspelled File Names

These are different files:

```text
status-check.sh
status-chect.sh
status-check-.sh
```

Linux file names are matched exactly.

## 28. Practical Bash Workflow

A practical Bash automation workflow is:

```text
Check prerequisites
-> Check files and directories
-> Create required resources
-> Install dependencies
-> Verify results
-> Print clear status messages
-> Return a success or failure status
```

Bash is especially useful for connecting:

- Linux commands
- Git
- Python
- Virtual environments
- Dependency management
- Testing tools
- Deployment systems

## 29. Key Summary

```text
Bash:
A command interpreter and automation language.

Shell script:
A text file containing Bash commands and control logic.

Variables:
Store values for later use.

Quotes:
Control whether text is literal or expanded.

Command substitution:
Runs a command and captures its output.

Exit status:
Reports command success or failure.

Arguments:
Pass input into scripts and functions.

Conditions:
Choose different execution paths.

Loops:
Repeat commands for multiple inputs.

Functions:
Organize reusable logic.

Environment checking:
Verifies that required tools and files are available.

Project setup:
Automates virtual environment creation and dependency installation.
```
