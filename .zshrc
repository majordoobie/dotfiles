#! /bin/bash
## Setup History
#
HISTFILE=$HOME/.zsh_history
SAVEHIST=100000
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


#
## bootstrap
#
zvm_after_init_commands+=('source <(fzf --zsh)')
eval "$(zoxide init zsh)"
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
# Bootstraps starship prompts
type starship_zle-keymap-select >/dev/null || \
{
    eval "$(starship init zsh)"
}


#
## Aliases
#
alias code="cd ~/code"
alias ll="ls -lAh --color=always"
alias dotfiles="cd ~/dotfiles"
alias obsidian_dotfiles="cd \"/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents\""

alias cnvim="cd ~/.config/nvim/ && nvim"
alias cnix="cd ~/dotfiles/nix; nvim flake.nix"
alias cd=z

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export XDG_CONFIG_HOME="$HOME/.config"
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
