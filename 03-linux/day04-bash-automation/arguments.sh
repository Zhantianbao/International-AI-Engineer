#!/usr/bin/env bash

echo "Script name: $0"
echo "Argument count: $#"

for argument in "$@"; do
	echo "Current argument: $argument"
done

