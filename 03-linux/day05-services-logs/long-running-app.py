#!/usr/bin/env python3

import time
from datetime import datetime

def current_time():
	return datetime.now().isoformat(timespec="seconds")

counter = 1

try:
	while True:
		print(
			f"{current_time()} [INFO] Application heartbeat {counter}",
            		flush=True,
        	)
		counter += 1
		time.sleep(2)

except KeyboardInterrupt:
	print(
		 f"{current_time()} [INFO] Application stopped by user",
        	flush=True,
	)

