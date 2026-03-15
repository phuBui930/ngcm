#!/usr/bin/env bash

DIR="$1"
non_modrinth=""

for file in "$DIR"/*; do
  id=$(yq -p toml ".update.modrinth.mod-id" < "$file")
  exit_code=$?
  if [[ $exit_code -eq 1 ]]; then
    echo "This file does not contain modrinth mod id" >&2
  fi
  name=$(yq -p toml ".name" < "$file")
  exit_code=$?
  if [[ $exit_code -eq 1 ]]; then
    echo "This file does not have mod name" >&2 
  fi 
  if [[ -n "$name" ]]; then
    link=https://modrinth.com/mod/$(curl "https://api.modrinth.com/v2/project/$id" | jq -r ".slug")
    echo "- [$name]($link)"
  else
    non_modrinth="$non_modrinth""- $(basename "$file")
"
  fi
done
echo "$non_modrinth"
