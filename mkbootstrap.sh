#!/usr/bin/env -S ./nix shell nixpkgs#nix-prefetch-git nixpkgs#parallel --command bash
# Generate Nix bootstrap package for Vim-Plug
# (c) Karim Vergnes <me@thesola.io>

set -e -o pipefail

first=1

_each_repo() {
    awk "match(\$0, /^Plug +'([^']*)'/, a) { print a[1] }" < init.vim.d/00-plugins.vim
}

_each_package() {
    for f in init.vim.d/*.lua goyo.vim.d/*.lua
    do
        awk 'match($0, /nix:path\("([^"]*)"/, a) { print a[1] }' < $f
    done
}

_each_lsp_package() {
    for f in init.vim.d/*.lua goyo.vim.d/*.lua
    do
        awk 'match($0, /nix:shell\("([^"]*)"/, a) { print a[1] }' <$f
    done
}

_prefetch_git() {
    repo=$(cut -d/ -f2 <<< $1)
    nix-prefetch-git --url https://github.com/$1 --quiet --fetch-submodules > /tmp/git-$repo
}

{
  echo -n '{ "repos": {'
  export -f _prefetch_git
  _each_repo | parallel --bar _prefetch_git >&2
  _each_repo \
  | while IFS= read -r line
    do
      repo=$(cut -d/ -f2 <<< $line)
      ((first)) || echo -n ","
      echo -n "\"$line\":"
      cat /tmp/git-$repo
      rm /tmp/git-$repo
      first=0
    done
  echo -n '}, "packages": ['
  first=1
  _each_package \
  | while IFS= read -r line
    do
      ((first)) || echo -n ","
      echo -n "\"$line\""
      first=0
    done
  echo -n '], "lsp-packages": ['
  first=1
  _each_lsp_package \
  | while IFS= read -r line
    do
      ((first)) || echo -n ","
      echo -n "\"$line\""
      first=0
    done
  echo ']}'
} > bootstrap.lock
