# squads

squads is my in-repo project manage automations.

it's mainly for my own use.

it's simple.

it stores everything in the repo togther with the code. it doesn't break my flow by forcing me to leave the terminal and keyboard to find out what's next to do.

## to install

copy `justfile`, `squads.just`, `hacks/squads` into the repo that you are working with

## to upgrade

```bash
just squads upgrade
```

Or directly with curl:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/neodejack/squads/main/upgrade.sh)
```

## to use

```bash
just squads
```
