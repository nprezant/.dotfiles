#!/usr/bin/env bash

# A vim8 package manager!
# Add packages below and run the script to add/update/delete.

# Location of vim packages
pack=$HOME/.vim/pack

# Create new folder in ~/.vim/pack that plugins can be installed in
# and cd into it.
#
# Arguments:
#   * name: (string) name of package, used in ~/.vim/pack/<name>.
#   * [startopt=start]: (string) whether this plugin should be added at
#     startup or with packadd. Used in ~/.vim/pack/<name>/<startopt>.
#
# Examples:
#   set_package syntax
#   set_package colorschemes opt
#
function set_package () {
    name=$1
    startopt=${2:-start}
    d="$pack/$name/$startopt"
    mkdir -p "$d"
    cd "$d" || exit
}

# Clone or update a git repo in the current directory.
#
# Arguments:
#   url: the URL to the git repo. repo should have folders like 'plugin' etc.
#
# Examples:
#   package https://github.com/tpope/vim-endwise.git
#
function package () {
    url=$1
    repo_dir=$(basename "$url" .git)
    if [ -d "$repo_dir" ]; then
        cd "$repo_dir" || exit
        result=$(git pull --force)
        echo "$repo_dir: $result"
    else
        echo "$repo_dir: Installing..."
        git clone "$url" --depth 1
    fi
}

echo "Checking packages..."

(
set_package fzf
package https://github.com/junegunn/fzf.git &
package https://github.com/junegunn/fzf.vim.git &
wait
) &

(
set_package colors opt
package https://github.com/morhetz/gruvbox.git &
wait
) &

(
set_package syntax
package https://github.com/keith/swift.vim.git &
package https://github.com/bfrg/vim-cpp-modern.git &
wait
) &

wait

echo "Generating help tags..."
vim +":helptags ALL" +":qa"

# Find any .git folder that was not just updated by this script call
# If such a folder exists, then it was possibly previously added by
# this script and then later removed.
old_plugs=$(find $pack/*/*/*/.git -prune -mmin +5 -print | sed "s/\/.git//")
if [ -n "$old_plugs" ]; then
    echo "Removing old plugins: $old_plugs"
    echo $old_plugs | xargs rm -rf
else
    echo "No plugins to remove."
fi

