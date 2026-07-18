#!usr/bin/env python3

import sys
from datetime import datetime

def current_time():
	return datetime.now().isoformat(timespec="seconds")

print(f"{current_time()} [INFO] Application started")
print(f"{current_time()} [INFO] Processing data")
print(
	f"{current_time()} [ERROR] This is an example error message",
	file=sys.stderr,
)
print(f"{current_time()} [INFO] Application finished")
