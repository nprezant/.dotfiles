# .dotfiles

There be dotfiles

# What is this?

This is a repository of dotfiles that can be easily copied from one machine to another.
The intent is for the repo to be essentially cloned to the home directory, but with a little git fancyness.

# How do I use it?

For simplistic usage, simply curl the raw files individually:

```console
curl <raw-.vimrc-path> > ~/.vimrc
```

For more sophisticated usage, either run this [gist](https://gist.github.com/nprezant/ac1d12ec0c9b1853023bc1ec50fd74bd) or follow the steps below.

## Setup script

```console
curl -Lks https://gist.githubusercontent.com/nprezant/ac1d12ec0c9b1853023bc1ec50fd74bd/raw/ | /bin/bash
```

## Setup script, explained

Clone the repo. We use a bare repo to allow the .git files to live in a folder (.dotfiles) while the actual dotfiles are relative to your home directory.

```console
git clone --bare https://github.com/nprezant/.dotfiles.git $HOME/.dotfiles
```

A longer git command is required to properly interact with the repo.
An alias is provided in the .zshrc file

```console
function dotfiles {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
```

Attempt to check out files. Git won't overwrite existing files (e.g. you already have a .vimrc) so existing files are backed up to .dotfiles-backup. A specialized `mv` function is used to create parent directories on the fly when backing up files.

```console
dotfiles checkout
if [[ $? == 0 ]]; then
    echo "Checked out dotfiles. No untracked files were overwritten.";
else
    echo "Backup up pre-existing dotfiles to $HOME/.dotfiles-backup"
    function mvp () {
        # Moves a file and creates parent directories as necessary
        dir="$2"
        last_c="$2"; last_c="${last_c: -1}"
        [[ "$last_c" != "/" ]] &&
            dir="$(dirname "$2")"
        [[ -e "$dir" ]] ||
            mkdir -p "$dir" &&
            mv "$@"
    }
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I _ mvp _ $HOME/.dotfiles-backup/_
    dotfiles checkout
fi;
```

Make sure we don't show untracked files (because that would be the whole home directory)

```console
dotfiles config --local status.showUntrackedFiles no
```

Re-source or restart programs for the changes to take effect.

```console
source ~/.zshrc
```
