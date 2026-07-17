#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
	echo "Usage: $0 <file>"
	exit 1
fi

target_file="$1"

ls "$target_file"
status="$?"

echo "Saved exit status: $status"

if [ "$status" -eq 0 ]; then
	echo "The file exists"
else
	echo "The file does not exist."
fi
