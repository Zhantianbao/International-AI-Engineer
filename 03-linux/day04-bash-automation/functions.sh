#!/usr/bin/env bash

greet() {
	local name="$1"
	echo "Hello, $name"
}

for person in "$@"; do
	greet "$person"
done
