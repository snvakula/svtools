#!/bin/bash

TOKEN="/Users/sv/.auth/github-token-snvakula"
WORKDIR="/Users/sv/Data/git/github/orgs"

cd "$WORKDIR"
for org in $(find . -type d -depth 1 | sed -e 's/^.\///'); do
  for rep in $(curl -H "Authorization: token $(cat $TOKEN)" "https://api.github.com/orgs/$org/repos?per_page=100" 2>/dev/null | grep -o 'git@[^"]*' | cut -d ':' -f2 | sed -e 's/.git$//'); do
    if [ -d "$rep/.git" ]; then
      echo "-------------------- Pulling $rep --------------------"
      git --git-dir="$rep/.git" --work-tree="$rep" pull --all -v
    else
      echo "-------------------- Cloning $rep --------------------"
      rm -rf "$rep"
      git clone "git@github.com:$rep.git" "$rep"
    fi
  done
done
