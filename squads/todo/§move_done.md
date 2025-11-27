§move_done

## overview

```
just squads::done todo_name
```

## user journey

running this command would move the file f"§{substring_match(todo_name)}.md" from `squads/todo/` to `squads/todo/done`

for exmaple, the `squads/todo/` looks like this

```
squads/todo
├── backlogs
├── done
├── §test.md
├── §test2.md
└── §ui_improvement.md
```

if users run `just squads::done ui`, and since `ui` matches one and only one file in `squads/todo/`, which is `§ui_improvement.md`, we proceed to move this file

if users run `just squads::done test`, and since `test` matches two files, we fail early and print out error message
if users run `just squads::done haha`, and since `haha` matches no files, we fail early and print out error message

## tech spec

fail early if:

- there are more than one substring_matched file
- there are none substring_matched file

give user helpful error messages, something along the lines of:

- "no files matches todo_name"
- "more than one files matches todo_name, and here they are: "
