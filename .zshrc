# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
#ZSH_THEME="chungus"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"


# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time


# Uncomment the following line to disable auto-setting terminal title.
 DISABLE_AUTO_TITLE="true"


# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
 COMPLETION_WAITING_DOTS="true"


plugins=(
	git
	colored-man-pages
	colorize
	docker
	pip
	sudo
	vi-mode
	fzf
)

source $ZSH/oh-my-zsh.sh

alias doobstation="cd '/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents/DoobStation'"
alias ll="ls -lAh"
alias code="cd ~/OneDrive/Code"
alias dotfiles="cd ~/dotfiles"
alias edit_nvim="cd ~/.config/nvim/"
export EDITOR="nvim"
export VISUAL="nvim" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init --cmd cd zsh)"
