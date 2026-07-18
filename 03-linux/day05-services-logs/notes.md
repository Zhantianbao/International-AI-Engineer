# Linux Day05 - Services, Logs, and Long-Running Processes

## 1. Program, Process, and Service

A program is executable code stored on disk.

Examples:

```text
/usr/bin/python3
/usr/bin/git
long-running-app.py
```

A process is a running instance of a program.

When this command is executed:

```bash
python3 long-running-app.py
```

Linux creates a Python process with its own:

- PID
- Memory
- CPU state
- Environment variables
- Working directory
- Open files
- Standard input
- Standard output
- Standard error

A service is a managed unit that provides a function to the system or users.

A service may contain one or more processes.

Example:

```text
systemd
-> manages cron.service
-> cron.service starts /usr/sbin/cron
-> cron runs as a process
```

## 2. Background Process and Daemon

A background process runs without occupying the Shell foreground.

Example:

```bash
python3 app.py &
```

The final `&` puts the command into the current Shell's background.

A daemon is normally a long-running, non-interactive process that provides a background function.

Examples include:

```text
cron
sshd
systemd-journald
```

A background process is not automatically a reliable system service.

A normal background process usually does not automatically provide:

- Startup at boot
- Automatic restart
- Dependency management
- Unified status management
- Centralized logging

## 3. Why Backend Applications Need Long-Running Services

A backend application must remain available to receive and process requests.

If the backend process exits:

```text
No running process
-> no application is available
-> requests cannot be processed
```

Production backend applications usually need:

- Long-running execution
- Startup after system boot
- Automatic restart after failure
- Unified logs
- Controlled permissions
- Stable process management

This is why backend applications are usually managed by tools such as:

- systemd
- Docker
- Kubernetes
- Supervisor

## 4. systemd

`systemd` is the system and service manager used by Ubuntu.

It commonly runs as PID 1:

```bash
ps -p 1 -o pid,ppid,user,comm,args
```

Typical relationship:

```text
Linux kernel
-> starts systemd as PID 1
-> systemd starts and manages other services
```

`systemd` manages objects called units.

Common unit types include:

```text
.service
.socket
.timer
.mount
.target
```

## 5. systemctl

`systemctl` is the command-line tool used to communicate with `systemd`.

The name can be understood as:

```text
system + control
```

Common commands:

```bash
systemctl status cron
sudo systemctl start cron
sudo systemctl stop cron
sudo systemctl restart cron
sudo systemctl enable cron
sudo systemctl disable cron
```

Meanings:

```text
status
Show the current service status.

start
Start the service immediately.

stop
Stop the service immediately.

restart
Stop the current process and start a new process.

enable
Configure the service to start automatically at system boot.

disable
Remove automatic startup at system boot.
```

## 6. start and enable Are Different

`start` changes the current runtime state:

```bash
sudo systemctl start cron
```

`enable` changes future boot behavior:

```bash
sudo systemctl enable cron
```

A service can be:

```text
active and disabled
Currently running, but not configured for automatic boot startup.

inactive and enabled
Currently stopped, but configured to start during the next boot.
```

Commands that perform both actions:

```bash
sudo systemctl enable --now cron
sudo systemctl disable --now cron
```

## 7. Service Status

Useful commands:

```bash
systemctl status cron --no-pager
systemctl is-active cron
systemctl is-enabled cron
systemctl show cron -p MainPID --value
```

Important fields:

```text
Loaded
Whether systemd successfully loaded the unit configuration.

Active
The current service runtime state.

Main PID
The main process ID managed by the service.

Tasks
The number of tasks associated with the service.

Memory
The memory used by the service.

CPU
The CPU time used by the service.

CGroup
The control group containing the service processes.
```

Restarting a service normally creates a new process and therefore a new PID.

## 8. Linux Logging Mechanism

`systemd-journald` collects system and service logs.

The collected logs are stored in the journal.

`journalctl` is the command used to query the journal.

Relationship:

```text
application or service
-> writes messages
-> systemd-journald collects messages
-> journal stores messages
-> journalctl displays messages
```

## 9. journalctl

View logs for a unit:

```bash
sudo journalctl -u cron
```

View the last 20 entries:

```bash
sudo journalctl -u cron -n 20 --no-pager
```

View logs from a specified time:

```bash
sudo journalctl -u cron --since "20 minutes ago" --no-pager
```

View today's logs:

```bash
sudo journalctl -u cron --since "today" --no-pager
```

Follow new logs in real time:

```bash
sudo journalctl -u cron -f
```

Important options:

```text
-u
unit

-n
number of recent entries

-f
follow new log entries

--since
show entries since a specified time

--no-pager
print directly without opening a pager
```

## 10. Reading Service Logs

A log entry commonly contains:

```text
timestamp
hostname
program or service name
process PID
message
```

Logs can show:

- When a service started
- When a service stopped
- Which command was executed
- Which process failed
- What exit status was returned
- Which file was missing
- Whether permission was denied
- Whether a port was already in use

## 11. Logs and Failure Diagnosis

`systemctl status` gives a quick status summary.

`journalctl` provides more detailed historical context.

Typical workflow:

```text
Service is not working
-> check service status
-> inspect recent logs
-> identify the error message
-> verify the process
-> verify required files and permissions
-> check listening ports when it is a network service
```

Common errors include:

```text
No such file or directory
A required file or executable path is wrong.

Permission denied
The service user does not have sufficient permission.

ModuleNotFoundError
The required Python dependency is missing.

Address already in use
Another process is already using the required port.

status=203/EXEC
systemd could not execute the configured command.

status=1/FAILURE
The program started but exited with failure status 1.
```

## 12. stdout, stderr, and File Descriptors

Linux programs commonly start with three standard file descriptors:

```text
0 = stdin  = standard input
1 = stdout = standard output
2 = stderr = standard error
```

By default:

```text
FD 0 -> current terminal
FD 1 -> current terminal
FD 2 -> current terminal
```

File descriptors 1 and 2 are different output channels, even when both point to the same terminal.

This allows Shell redirection to manage them independently.

## 13. Output Redirection

Redirect stdout:

```bash
python3 logging-demo.py > stdout.log
```

This is equivalent to:

```bash
python3 logging-demo.py 1> stdout.log
```

Redirect stderr:

```bash
python3 logging-demo.py 2> stderr.log
```

Redirect both to different files:

```bash
python3 logging-demo.py > stdout.log 2> stderr.log
```

Redirect both to one file:

```bash
python3 logging-demo.py > combined.log 2>&1
```

The expression:

```text
2>&1
```

means:

```text
Make file descriptor 2 point to the location currently used by file descriptor 1.
```

Redirection order matters.

## 14. Python Application Logging

Python's `print()` normally writes to stdout:

```python
print("normal message")
```

Errors can be written to stderr:

```python
import sys

print("error message", file=sys.stderr)
```

The `file` parameter specifies the output stream used by `print()`.

## 15. Output Buffering

When stdout points to a file, output may be buffered.

This means messages may remain temporarily in memory before being written to the file.

To immediately write a message:

```python
print("heartbeat", flush=True)
```

Another option is unbuffered Python mode:

```bash
python3 -u application.py
```

`flush=True` is useful for:

- Real-time logs
- Long-running applications
- Background programs
- Monitoring application activity

## 16. Long-Running Python Application

The Day05 application uses:

```python
while True:
```

to run continuously.

It uses:

```python
time.sleep(2)
```

to wait two seconds between heartbeat messages.

It handles:

```python
KeyboardInterrupt
```

so that `Ctrl + C` or `SIGINT` can stop it cleanly.

## 17. Running a Process in the Background

Example:

```bash
python3 long-running-app.py > long-running-app.log 2>&1 &
```

The final `&` means:

```text
Run the command as a background job in the current Shell.
```

The special parameter:

```bash
$!
```

contains the PID of the most recently started background process.

Example:

```bash
app_pid=$!
echo "$app_pid" > long-running-app.pid
```

## 18. Monitoring Background Jobs and Processes

Show jobs managed by the current Shell:

```bash
jobs
jobs -l
```

Search system processes:

```bash
pgrep -af long-running-app.py
```

Check a specific PID:

```bash
ps -p 3904 -o pid,ppid,user,stat,etime,cmd
```

View recent logs:

```bash
tail -n 5 long-running-app.log
```

Follow logs:

```bash
tail -f long-running-app.log
```

`jobs` only shows jobs managed by the current Shell.

`pgrep` and `ps` inspect processes in the operating system.

## 19. Process Signals

`kill` sends a signal to a process.

Send SIGINT:

```bash
kill -INT PID
```

`INT` means interrupt.

It is similar to pressing:

```text
Ctrl + C
```

Common signals:

```text
SIGINT
Interrupt the process. The program may handle it.

SIGTERM
Request normal termination. This is the default signal used by kill.

SIGKILL
Force immediate termination. The program cannot handle or ignore it.
```

Use SIGKILL only when normal termination methods fail.

## 20. Basic Service Troubleshooting Workflow

### Check whether the process exists

```bash
pgrep -af application-name
```

### Check service status

```bash
systemctl status service-name --no-pager
```

### Check application or service logs

```bash
sudo journalctl -u service-name -n 50 --no-pager
```

### Check listening ports

```bash
sudo ss -ltnp
```

For a specific expected port:

```bash
sudo ss -ltnp | grep ':8000'
```

A process existing does not always mean a network service is ready.

A backend process may exist while failing to listen on its configured port.

## 21. Key Summary

```text
Program
Executable code stored on disk.

Process
A running instance of a program.

Background process
A process running without occupying the Shell foreground.

Daemon
A long-running non-interactive background process.

Service
A managed unit that provides a system or application function.

systemd
The system and service manager.

systemctl
The command-line tool used to control systemd.

journalctl
The command used to query system and service logs.

stdout
Normal program output through file descriptor 1.

stderr
Error and diagnostic output through file descriptor 2.

Listening port
A network endpoint where a service waits for connections.

Troubleshooting
Check the process, status, logs, and listening ports.
```
