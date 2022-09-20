# Beginning of lines configured by zsh-new-user-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/noah/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Enable autocomplection of aliases
setopt COMPLETE_ALIASES

# Don't auto-cd, must explicitly use cd command to cd
unsetopt auto_cd

# Enable automatic directory stack (use popd to go back)
setopt autopushd

# Stop making noises
unsetopt beep

# Use autocompletion with an arrow key interface.
# Press tab twice to activate
zstyle ':completion:*' menu select

# Aliases
alias ls="ls --color"
alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias i3config="vim ~/.config/i3/config"

# Preferred Editor
export EDITOR='vim'

# Make history better (match up until cursor)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Activate the directory colors so GNU core utils respect them...
test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

# Allow prompt to have expressions substituted
# And make the prompt nice
setopt prompt_subst
autoload -U colors && colors
PROMPT=
PROMPT+="%{$fg[magenta]%}%n@%m" # user@host
PROMPT+='%{$fg[cyan]%}[%~% ]' # current directory
PROMPT+='%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b ' # '$' either red or green depending on last command return value

# Setup keychain to remember ssh keys
eval `keychain --eval --quiet --agents ssh id_np_github`

# Alias for dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

