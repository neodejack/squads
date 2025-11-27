list:
  @just --list squads --list-heading $'Squads related stuff\n' --list-prefix '■ '

init:
  @hacks/squads/init.py

todo todo_name:
  @hacks/squads/todo.py "{{todo_name}}"
  @echo "§{{todo_name}}" | pbcopy

done todo_name:
  @hacks/squads/done.py "{{todo_name}}"

upgrade:
  #!/usr/bin/env bash
  bash <(curl -fsSL https://raw.githubusercontent.com/neodejack/squads/main/upgrade.sh)
