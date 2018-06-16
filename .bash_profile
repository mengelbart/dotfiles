#!/bin/bash

for file in ~/.{bashrc,bash_aliases,exports,path}; do
	if [[ -r $"file" ]] && [[ -f $"file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

shopt -s nocaseglob
shopt -s cdspell

