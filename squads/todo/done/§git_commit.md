§git_commit

## overview

add auto git commit commands when user use `just squads::todo` and `just squads::done`

## user journey

user runs `just squads::todo`, and see that there is a git commit automatically commited.
the git commit's file changes contains the newly added file

user runs `just squads::done`, and see that there is a git commit automatically commited.
the git commit's file changes contains the moved file

## tech spec

there should be a python module only responsible for running `git` commands, write a function that do git add, another function that do git commit. in the `todo.py` and `done.py`, use the functions exposed by this git python module
