#!/bin/bash

set -e

main() {
	  while IFS= read -r todo; do
			printf "%s\n" "$(line_author) $(message)"
		done < <(todo_list)
}

todo_list() {
	  grep -InR 'TODO' ./* \
			--exclude-dir=node_modules \
			--exclude-dir=public \
			--exclude-dir=vendor \
			--exclude-dir=compiled \
			--exclude-dir=git-hooks
}

line_author() {
	  LINE=$(line_number "$todo")
		FILE=$(file_path "$todo")
		tput setaf 6
		printf "%s" "$(git log --pretty=format:"%cN" -s -L "$LINE","$LINE":"$FILE" | head -n 1)"
		tput sgr0
}

file_path() {
	  printf "%s" "$todo" | cut -d':' -f 1
}

line_number() {
	  printf "%s" "$todo" | cut -d':' -f 2
}

message() {
	  printf "%s" "$todo" | xargs
}

main

exit 0
