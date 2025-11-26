list:
  @just --list squads --list-heading $'Squads related stuff\n' --list-prefix '■ '

init:
  @hacks/squads_init.py

todo todo_name:
  @hacks/squads_todo.py "{{todo_name}}"
