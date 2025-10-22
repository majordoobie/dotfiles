#
## Setup History
#
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
unsetopt hist_beep

#
## Plugins are managed by nix
#

#
## Path management
#
typeset -U path
path+=(/opt/homebrew/bin)

## Aliases
#
alias code="cd ~/code"
alias ll="ls -lAh --color=always"
alias dotfiles="cd ~/dotfiles"

alias cnvim="cd ~/.config/nvim/ && nvim"
alias cnix="cd ~/dotfiles/nix; nvim flake.nix"

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export XDG_CONFIG_HOME="$HOME/.config"
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
