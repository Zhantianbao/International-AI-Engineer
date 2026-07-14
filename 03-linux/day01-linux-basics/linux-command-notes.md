# Linux Day01 Notes
## Commands Learned

### Navigation

- pwd: print working directory, show current path
- ls: list files and directories
- cd: change directory
- cd ..: move to parent directory
- cd ~: move to home directory
- cd -: return to previous directory

### File Operations

- touch: create an empty file
- cat: display file contents
- cp: copy files
- mv: move or rename files
- rm: remove files

### Options

- -l: long listing format
- -a: show hidden files
- -h: human-readable format
- -d: show directory itself

### Important Paths

- / : root directory
- ~ : home directory
- . : current directory
- .. : parent directory

### Directory Management

- mkdir: make directory, create directories
- mkdir -p: create parent directories automatically
- rmdir: remove empty directories
- tree: display directory structure

### Searching

- find: search files and directories
- grep: global regular expression print, search text content

### File Viewing

- head: show the beginning of files
- tail: show the end of files
- tail -f: follow file changes in real time
- wc: count lines, words and characters

### File Permissions

- chmod: change file mode (permissions)
- r: read permission
- w: write permission
- x: execute permission

Permission categories:

- u: user (owner)
- g: group
- o: others
- a: all

Examples:

- chmod u+x file.sh: add execute permission for owner
- chmod g-w file.sh: remove write permission from group

### Users and Groups

- uid: user ID
- gid: group ID
- groups: groups that a user belongs to

### Environment Variables

- PATH: directories searched for executable programs
- echo $PATH: display PATH variable
- which command: show command location
