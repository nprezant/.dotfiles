# ---------------------------------------------------------
# Completion
# ---------------------------------------------------------
zstyle :compinstall filename '/home/noah/.zshrc'

autoload -Uz compinit
compinit

# Fish-like syntax highlighting and autosuggestions
# Install zsh-syntax-highlighting, zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable autocomplection of aliases
setopt COMPLETE_ALIASES

# Use autocompletion with an arrow key interface.
# Press tab twice to activate
zstyle ':completion:*' menu select

# ---------------------------------------------------------
# Key bindings
# ---------------------------------------------------------
# Generally a vi inspired mode
bindkey -v

# Create a zkbd compatile hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word


# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# ---------------------------------------------------------
# History searching (match up until cursor)
# ---------------------------------------------------------
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# ---------------------------------------------------------
# Misc
# ---------------------------------------------------------
# Don't auto-cd, must explicitly use cd command to cd
unsetopt auto_cd

# Enable automatic directory stack (use popd to go back)
setopt autopushd

# Stop making noises
unsetopt beep

# Preferred Editor
export EDITOR='vim'
export TERM='linux'

# Note: may be helpful to run this when ssh-ing
#stty sane

# ---------------------------------------------------------
# Aliases
# ---------------------------------------------------------
alias ls="ls --color"
alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias i3config="vim ~/.config/i3/config"

# Alias for dotfiles management
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ---------------------------------------------------------
# History
# ---------------------------------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Activate the directory colors so GNU core utils respect them...
test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

# ---------------------------------------------------------
# Prompt
# ---------------------------------------------------------
# Allow prompt to have expressions substituted
# And make the prompt nice
setopt prompt_subst
autoload -U colors && colors
PROMPT=
PROMPT+="%{$fg[green]%}%n%f@%{$fg[magenta]%}%m" # user@host
PROMPT+='%{$fg[cyan]%}[%~% ]' # current directory
PROMPT+='%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b ' # '$' either red or green depending on last command return value
RPROMPT='[%F{yellow}%?%f]'

# ---------------------------------------------------------
# SSH
# ---------------------------------------------------------
# Setup keychain to remember ssh keys
eval `keychain --eval --quiet --agents ssh id_rsa`

