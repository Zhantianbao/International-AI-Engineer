# Linux Final Learning Notes

## 1. Linux File System and Shell

Linux organizes files in a hierarchical tree beginning at `/`.

Important paths:

- `/`: root directory
- `/home`: home directories of ordinary users
- `/etc`: system configuration files
- `/var`: variable data such as logs
- `/tmp`: temporary files
- `/usr/bin`: common user commands
- `/usr/sbin`: system administration commands
- `/proc`: process and kernel information
- `~`: current user's home directory
- `.`: current directory
- `..`: parent directory

Important commands:

```bash
pwd
ls -la
cd
mkdir -p
touch
cp
mv
rm
cat
less
head
tail
find
tree
```

A relative path is resolved from the current working directory.

An absolute path begins with `/`.

Example:

```bash
pwd
/home/skybaby

cat Documents/file.txt
```

The relative path is resolved as:

```text
/home/skybaby/Documents/file.txt
```

---

## 2. Permissions and Users

Linux permissions are divided into:

```text
owner
group
others
```

Permission values:

```text
4 = read
2 = write
1 = execute
```

Examples:

```text
700 = owner has read, write, and execute permissions
600 = owner has read and write permissions
644 = owner can read and write; others can only read
755 = owner can modify; everyone can read and execute
```

Useful commands:

```bash
chmod 700 directory
chmod 600 private-file
chown user:group file
id
whoami
```

For directories, execute permission means that a user may enter the directory and access items inside it.

---

## 3. Processes and Job Control

A process is a running instance of a program.

Important terms:

- PID: Process Identifier
- PPID: Parent Process Identifier
- foreground process: occupies the current terminal
- background process: runs while the shell continues accepting commands
- exit status: result code returned by a command

Useful commands:

```bash
ps
ps -ef
ps -fp PID
pgrep -af PATTERN
top
kill PID
jobs
fg
bg
```

Shell variables:

```text
$$  = current shell PID
$!  = most recently started background process PID
$?  = previous command's exit status
```

General exit-status convention:

```text
0     success
non-0 failure or another exceptional condition
```

Start a background process:

```bash
command &
```

Save its PID:

```bash
echo $! > app.pid
```

Stop it later:

```bash
kill "$(cat app.pid)"
```

---

## 4. Standard Streams, Redirection, and Pipes

Every process normally has three standard streams:

```text
0 = standard input
1 = standard output
2 = standard error
```

Common redirections:

```bash
command > output.txt
command >> output.txt
command 2> error.txt
command > all.log 2>&1
```

Meaning:

```text
>       overwrite standard output destination
>>      append standard output
2>      redirect standard error
2>&1    send standard error to the current standard-output destination
```

Pipe:

```bash
command1 | command2
```

The standard output of `command1` becomes the standard input of `command2`.

Example:

```bash
ss -ltnp | grep ':8000'
```

---

## 5. Bash Scripts and Automation

A Bash script groups commands into a reusable program.

Example:

```bash
#!/usr/bin/env bash

set -euo pipefail

printf '%s\n' "Starting task"
```

Important concepts:

- shebang: selects the interpreter
- variable: stores data
- positional parameter: receives command-line arguments
- condition: controls execution
- loop: repeats commands
- function: groups reusable logic

Useful syntax:

```bash
name="value"
printf '%s\n' "$name"

if condition; then
    command
fi

for item in list; do
    command
done
```

`set -euo pipefail` improves script reliability:

```text
-e          stop when a command fails
-u          treat unset variables as errors
-o pipefail make a pipeline fail when one component fails
```

---

## 6. Python Virtual Environments

`venv` means Virtual Environment.

A virtual environment isolates Python packages for one project.

Create and activate:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Verify:

```bash
which python
echo "$VIRTUAL_ENV"
python -m pip --version
```

Install packages:

```bash
python -m pip install Flask
```

Record dependencies:

```bash
python -m pip freeze > requirements.txt
```

Rebuild the environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python -m pip check
```

Using `python -m pip` ensures that `pip` belongs to the same Python interpreter currently being used.

A virtual environment should normally be rebuilt rather than copied or moved.

`.venv` must not be committed to Git.

---

## 7. Services and systemd

A service is a long-running program managed by the operating system.

`systemd` is the service and system manager used by Ubuntu.

Important commands:

```bash
systemctl status SERVICE
systemctl start SERVICE
systemctl stop SERVICE
systemctl restart SERVICE
systemctl enable SERVICE
systemctl disable SERVICE
systemctl is-active SERVICE
systemctl is-enabled SERVICE
```

Example:

```bash
sudo systemctl enable --now ssh
```

Meaning:

```text
enable = start automatically during system boot
--now  = also start immediately
```

Service logs can be inspected with:

```bash
journalctl -u SERVICE
journalctl -u SERVICE -n 50
journalctl -u SERVICE -f
```

---

## 8. Networking Fundamentals

Important concepts:

- IP address: identifies a network interface
- MAC address: data-link-layer hardware address
- route: determines where packets are sent
- DNS: resolves names into IP addresses
- port: identifies a network service on a machine
- socket: kernel object used for communication
- TCP: reliable connection-oriented protocol
- UDP: connectionless datagram protocol

Useful commands:

```bash
ip address
ip route
ping HOST
getent hosts NAME
ss -ltnp
curl URL
```

`ss` means Socket Statistics.

Example:

```bash
ss -ltnp
```

Options:

```text
-l = listening sockets
-t = TCP sockets
-n = numeric addresses and ports
-p = owning processes
```

Common address meanings:

```text
127.0.0.1
IPv4 loopback address; accessible only from the same machine

0.0.0.0
all local IPv4 interfaces

[::]
all local IPv6 interfaces
```

A complete network diagnosis may follow:

```text
process
→ socket
→ listening address and port
→ network route
→ HTTP request
```

---

## 9. SSH Remote Management

SSH means Secure Shell.

It provides encrypted remote command execution and remote Shell access.

Communication model:

```text
SSH client
    ↓ encrypted TCP connection
SSH server process: sshd
    ↓
remote Shell
```

Basic syntax:

```bash
ssh user@host
ssh -p PORT user@host
```

The default SSH TCP port is:

```text
22
```

Important components:

```text
ssh
client program

sshd
SSH server daemon

ssh.service
Ubuntu systemd service

known_hosts
servers trusted by the client

authorized_keys
user public keys trusted by the server
```

Check the SSH server:

```bash
systemctl status ssh
sudo ss -ltnp | grep ':22'
```

---

## 10. SSH Host Authentication

The SSH server owns host keys.

The client uses the server host key to verify that it connected to the expected server.

During the first connection, SSH shows a fingerprint:

```text
ED25519 key fingerprint is SHA256:...
```

After confirmation, the server identity is recorded in:

```text
~/.ssh/known_hosts
```

Roles:

```text
host key
proves the identity of the SSH server

known_hosts
stores trusted SSH server identities
```

A changed host key may produce:

```text
REMOTE HOST IDENTIFICATION HAS CHANGED
```

This may indicate a rebuilt server, a changed IP assignment, an obsolete local entry, or a possible attack.

---

## 11. SSH Public-Key Authentication

A key pair consists of:

```text
private key
public key
```

The private key remains on the client.

The public key is installed on the server.

Generate a key pair:

```bash
ssh-keygen \
    -t ed25519 \
    -f ~/.ssh/day07_ed25519 \
    -C "day07-learning"
```

Generated files:

```text
~/.ssh/day07_ed25519
private key

~/.ssh/day07_ed25519.pub
public key
```

Recommended permissions:

```text
~/.ssh                         700
private key                    600
public key                     644
~/.ssh/authorized_keys         600
```

Install the public key:

```bash
ssh-copy-id \
    -i ~/.ssh/day07_ed25519.pub \
    user@host
```

Test authentication:

```bash
ssh \
    -i ~/.ssh/day07_ed25519 \
    -o IdentitiesOnly=yes \
    user@host
```

Authentication model:

```text
client uses private key to create a signature
        ↓
server uses authorized public key to verify it
        ↓
authentication succeeds
```

The private key is never sent to the server.

Security rules:

```text
Never upload a private key.
Never commit a private key to Git.
Never send a private key to another person.
Use restrictive file permissions.
Use a passphrase for long-term personal keys.
```

---

## 12. SCP Secure File Transfer

`scp` means Secure Copy.

It transfers files through SSH.

General syntax:

```bash
scp SOURCE DESTINATION
```

Local to remote:

```bash
scp \
    -i ~/.ssh/day07_ed25519 \
    local-file.txt \
    user@host:/remote/path/file.txt
```

Remote to local:

```bash
scp \
    -i ~/.ssh/day07_ed25519 \
    user@host:/remote/path/file.txt \
    local-file.txt
```

Transfer a directory:

```bash
scp -r local-directory user@host:/remote/path/
```

`-r` means recursive.

A remote path is identified by:

```text
user@host:/path
         ^
         colon separates the remote host from its path
```

`scp` does not read `.gitignore`.

---

## 13. Application Deployment Workflow

The completed deployment workflow was:

```text
Develop source code locally
        ↓
Create a local virtual environment
        ↓
Install dependencies
        ↓
Run and test the application locally
        ↓
Generate requirements.txt
        ↓
Upload source code with SCP
        ↓
Log in to the remote machine with SSH
        ↓
Create a new remote virtual environment
        ↓
Install requirements.txt
        ↓
Check dependencies
        ↓
Start the application
        ↓
Inspect process, logs, and ports
        ↓
Test HTTP endpoints with curl
```

Local development files:

```text
deployment-app/
├── app.py
└── requirements.txt
```

Remote deployment path:

```text
/home/skybaby/day07-remote-deployment/deployment-app
```

The local and remote virtual environments were created separately.

---

## 14. Running a Long-Lived Application

Example background start:

```bash
nohup env PYTHONUNBUFFERED=1 \
    .venv/bin/python app.py \
    > app.log 2>&1 &

echo $! > app.pid
```

Meaning:

```text
nohup
keep the program running after terminal disconnection

PYTHONUNBUFFERED=1
write Python output to the log promptly

> app.log
redirect standard output to the log file

2>&1
redirect standard error to the same log file

&
run in the background

$!
PID of the most recently started background process
```

Inspect the application:

```bash
ps -fp "$(cat app.pid)"
cat app.log
ss -ltnp | grep ':8000'
curl -i http://127.0.0.1:8000/health
```

Stop it:

```bash
kill "$(cat app.pid)"
```

---

## 15. Deployment Troubleshooting

### Missing dependency

Symptom:

```text
ModuleNotFoundError: No module named 'flask'
```

Diagnosis:

```text
application fails during import
→ inspect error log
→ inspect packages in the active environment
→ required package is missing
```

Fix:

```bash
python -m pip install -r requirements.txt
python -m pip check
```

### Port conflict

Symptom:

```text
Address already in use
Port 8000 is in use by another program
```

Diagnosis:

```bash
ss -ltnp | grep ':8000'
ps -fp PID
```

Cause:

```text
another process already owns the listening socket
```

Possible fixes:

```text
stop the existing process
or
run the new service on another port
```

### Application crash

Example configuration error:

```bash
PORT=abc python app.py
```

Python attempts:

```python
int("abc")
```

and raises:

```text
ValueError
```

Diagnosis chain:

```text
application exits
→ no listening port appears
→ inspect log and traceback
→ locate the failing source-code line
→ identify invalid configuration
```

---

## 16. Troubleshooting Model

A useful troubleshooting order is:

```text
1. Reproduce the problem
2. Read the exact error message
3. Check the exit status
4. Inspect the process
5. Inspect logs
6. Inspect listening ports and sockets
7. Test the service with curl
8. Change one cause at a time
9. Verify the fix
```

Layered diagnosis:

```text
Application code
        ↓
Python environment and dependencies
        ↓
Process state
        ↓
Logs
        ↓
Socket and port
        ↓
Network access
        ↓
HTTP response
```

---

## 17. Git Safety Rules

Files that should not be committed:

```text
.venv/
.env
private SSH keys
runtime PID files
runtime logs
Python cache files
IDE configuration
```

Typical `.gitignore` entries:

```gitignore
.venv/
.env
__pycache__/
*.pyc
*.pid
*.log
.idea/
```

Before committing:

```bash
git status
git diff
git diff --cached
```

---

## 18. Complete Linux Module Review

### Day01 — Linux Basics

- file-system hierarchy
- paths
- files and directories
- permissions
- users
- PATH
- basic Git operations in Linux

### Day02 — Processes and Shell

- processes and PIDs
- foreground and background jobs
- standard streams
- redirection
- pipes
- process inspection
- `/proc`

### Day03 — Python Environment

- APT packages
- pip
- virtual environments
- Python package installation
- requirements.txt
- rebuilding environments

### Day04 — Bash Automation

- scripts
- variables
- arguments
- conditions
- loops
- functions
- exit status
- safer shell scripting

### Day05 — Services and Logs

- long-running processes
- systemd
- systemctl
- journalctl
- service status
- background execution
- application logs

### Day06 — Networking

- interfaces
- IP addresses
- routes
- DNS
- TCP ports
- sockets
- ss
- curl
- connection refused
- port occupation

### Day07 — SSH and Final Deployment

- SSH client and server
- sshd
- host authentication
- password authentication
- public-key authentication
- SSH key permissions
- SCP file and directory transfer
- local application verification
- remote environment creation
- remote deployment
- process, log, port, and HTTP inspection
- missing dependency
- port conflict
- application crash

---

## 19. Final Understanding

I can now explain and perform this workflow:

```text
Prepare an application
→ isolate dependencies
→ verify it locally
→ transfer it securely
→ connect to a remote Linux machine
→ recreate the environment
→ start the service
→ inspect the process
→ inspect logs
→ inspect the listening port
→ test HTTP access
→ diagnose and repair deployment failures
```

Linux deployment is not one command. It is a chain involving:

```text
files
permissions
users
processes
Shell
Python environments
services
logs
network sockets
SSH
HTTP
Git
