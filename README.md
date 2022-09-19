# .dotfiles

There be dotfiles

# What is this?

This is a repository of dotfiles that can be easily copied from one machine to another.
The intent is for the repo to be essentially cloned to the home directory, but with a little git fancyness.

# How do I use it?

For simplistic usage, simply curl the raw files:

```console
curl <raw-.vimrc-path> > ~/.vimrc
```

For more sophisticated usage, follow these steps:

```console
# clone the repo
git clone --bare git@github.com:nprezant/.dotfiles.git $HOME/.dotfiles

# set up shortcut for interacting with the repo (true alias provided in the .zshrc dotfile)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# attempt to check out files. backup existing files if necessary
dotfiles checkout
if [ $? == 0 ]; then
    echo "Checked out dotfiles. No files were overwritten";
else
    echo "Backup up pre-existing dotfiles to $HOME/.dotfiles-backup"
    mkdir -p $HOME/.dotfiles-backup
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I _ mv _ $HOME/.dotfiles-backup/_
    dotfiles checkout
fi;

# don't show untracked files (because that's the whole home directory)
dotfiles config --local status.showUntrackedFiles no
```
