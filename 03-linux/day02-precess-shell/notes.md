````markdown
# Linux Day02 - Process and Shell Basics

## 1. Process Basics

### What is a Process?

A process is a running instance of a program.

When a program starts, the Linux kernel creates a process to manage its execution.

Each process has a unique identifier:

- PID (Process ID): identifier of a process.
- PPID (Parent Process ID): identifier of the parent process that created this process.

Example:

```text
terminal
   |
 bash (PID 3581)
   |
 command
````

---

# 2. ps Command

`ps` means:

```text
ps = Process Status
```

It is used to display information about running processes.

## Basic usage

```bash
ps
```

Shows processes related to the current terminal.

Example:

```text
PID     TTY      TIME     CMD
3581    pts/0    00:00    bash
```

---

## ps fields

### PID

```text
PID = Process ID
```

Unique identifier of a process.

---

### TTY

```text
TTY = Teletypewriter
```

Originally referred to physical terminals.

In modern Linux:

TTY represents the terminal associated with a process.

Example:

```text
pts/0
```

`pts` means:

```text
PTS = Pseudo Terminal Slave
```

It represents a virtual terminal created by a terminal emulator.

---

### TIME

CPU time consumed by the process.

It is NOT the time since the process started.

Example:

A bash process may run for hours but:

```text
TIME = 00:00:00
```

because it uses almost no CPU.

---

### CMD

```text
CMD = Command
```

The command used to start the process.

Example:

```text
bash
python app.py
```

---

# 3. Viewing More Processes

## ps aux

```bash
ps aux
```

Shows all processes.

Important columns:

| Field   | Meaning                   |
| ------- | ------------------------- |
| USER    | User who owns the process |
| PID     | Process ID                |
| %CPU    | CPU usage percentage      |
| %MEM    | Memory usage percentage   |
| VSZ     | Virtual memory size       |
| RSS     | Resident memory size      |
| TTY     | Terminal                  |
| STAT    | Process status            |
| COMMAND | Command                   |

---

## ps -ef

```bash
ps -ef
```

Another full process format.

Important fields:

### UID

```text
UID = User ID
```

The user identifier.

---

### PPID

```text
PPID = Parent Process ID
```

The identifier of the parent process.

Example:

```text
PID     PPID

2181
 |
3581 bash
```

---

### C

CPU usage related value.

---

### STIME

```text
STIME = Start Time
```

The time when the process started.

---

# 4. Process Tree

Command:

```bash
pstree
```

Shows parent-child relationships between processes.

Example:

```text
systemd
 |
 terminal
 |
 bash
 |
 command
```

Linux processes form a tree structure.

---

# 5. Process Control

## sleep

Example:

```bash
sleep 1000
```

Creates a process that waits for a specified amount of time.

Useful for practicing process management.

---

## kill

Terminate a process:

```bash
kill PID
```

Default signal:

```text
SIGTERM
```

Allows the process to clean up before exiting.

---

## kill -9

Force terminate:

```bash
kill -9 PID
```

Signal:

```text
SIGKILL
```

The kernel immediately stops the process.

---

## killall

Terminate processes by name:

```bash
killall process_name
```

---

# 6. Background Jobs

Run command in background:

```bash
command &
```

Example:

```bash
sleep 1000 &
```

---

## jobs

Show shell jobs:

```bash
jobs
```

Job ID is managed by the shell.

It is different from PID.

---

## fg

Move a background job to foreground:

```bash
fg
```

---

## bg

Continue a stopped job in background:

```bash
bg
```

---

# 7. top Command

`top` provides real-time process monitoring.

Run:

```bash
top
```

Important columns:

## %CPU

CPU usage percentage.

---

## %MEM

Memory usage percentage.

---

## VIRT

```text
VIRT = Virtual Memory
```

Virtual address space used by a process.

It does not represent real RAM usage.

---

## RES

```text
RES = Resident Memory
```

Actual physical memory occupied by the process.

The most important value when checking memory usage.

---

## SHR

```text
SHR = Shared Memory
```

Memory shared with other processes.

---

Useful keys:

```text
P
```

Sort processes by CPU usage.

```text
M
```

Sort processes by memory usage.

```text
q
```

Quit top.

---

# 8. /proc File System

Linux provides process information through:

```text
/proc/PID
```

Example:

```text
/proc/3581
```

represents process PID 3581.

---

Important files:

## status

```bash
cat /proc/PID/status
```

Shows process information.

Important fields:

### State

Example:

```text
State: S (sleeping)
```

Common states:

| State | Meaning  |
| ----- | -------- |
| R     | Running  |
| S     | Sleeping |
| T     | Stopped  |
| Z     | Zombie   |

---

### VmSize

```text
VmSize = Virtual Memory Size
```

Virtual memory size.

Corresponds to:

```text
top VIRT
```

---

### VmRSS

```text
VmRSS = Virtual Memory Resident Set Size
```

Actual physical memory used.

Corresponds to:

```text
top RES
```

---

### Threads

Number of threads in the process.

---

## cwd

```bash
ls -l /proc/PID/cwd
```

Meaning:

```text
cwd = Current Working Directory
```

The current directory of the process.

---

## exe

```bash
ls -l /proc/PID/exe
```

Meaning:

```text
exe = executable
```

The actual program file used to start the process.

---

# 9. File Descriptor

File descriptor:

```text
fd = File Descriptor
```

A number used by a process to access files and devices.

View:

```bash
ls -l /proc/PID/fd
```

---

Standard file descriptors:

| FD | Name   | Purpose         |
| -- | ------ | --------------- |
| 0  | stdin  | Standard input  |
| 1  | stdout | Standard output |
| 2  | stderr | Standard error  |

---

Example:

```text
0 -> /dev/pts/0
1 -> /dev/pts/0
2 -> /dev/pts/0
```

Means:

The process receives input from the terminal and outputs to the terminal.

---

# 10. Redirection

Shell changes file descriptor connections.

## stdout redirection

```bash
command > file
```

Equivalent:

```bash
command 1> file
```

Changes:

```text
stdout(1)
    |
    file
```

---

## stderr redirection

```bash
command 2> file
```

Changes:

```text
stderr(2)
    |
    file
```

---

## Combine stdout and stderr

```bash
command > file 2>&1
```

Meaning:

1. Redirect stdout to file.
2. Redirect stderr to stdout.

Result:

```text
stdout
   |
 file

stderr
   |
 stdout
   |
 file
```

---

# 11. Pipe

Pipe symbol:

```text
|
```

`pipe` means connecting two commands together.

A pipe connects one command's output to another command's input.

Example:

```bash
ps aux | grep python
```

Implementation:

```text
process A

stdout(1)

   |
 pipe

   |

stdin(0)

process B
```

---

Multiple pipes:

```bash
cat file | grep hello | wc -l
```

Commands can be connected in sequence.

---

# 12. Core Understanding

Linux shell operations are based on processes and file descriptors.

The relationship is:

```text
Command
   |
Process
   |
PID
   |
File Descriptor
   |
stdin / stdout / stderr
   |
Redirection and Pipe
```

Understanding this helps with future Linux server deployment and AI application development.

```
```
