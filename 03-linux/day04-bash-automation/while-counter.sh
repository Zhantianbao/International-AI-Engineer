#!/usr/bin/env bash

count=1

while [ "$count" -le 3 ]; do
	echo "Current count: $count"
	count=$((count + 1))
done

echo "Loop finished."
