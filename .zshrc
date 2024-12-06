# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
#ZSH_THEME="chungus"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"


# Uncomment one of the following lines to change the auto-uomz updatepdate behavior
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

    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-vi-mode
)

if [[ $(uname) == "Darwin" ]]; then
    alias doobstation="cd '/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents/DoobStation'"
    export PATH="/opt:/opt/codelldb_v1.11/:/opt/homebrew/opt/llvm/bin:~/.cargo/bin:$PATH"

    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    zvm_after_init_commands+=('source <(fzf --zsh)')

else
    export PATH="/home/doobie/go/bin/:$PATH"
    
    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')
fi

source $ZSH/oh-my-zsh.sh

alias code="cd ~/code"
alias ll="ls -lAh"
alias dotfiles="cd ~/dotfiles"
alias nvim_edit="cd ~/.config/nvim/ && nvim"
alias git_push="git add . && git commit -m \"update\" && git push"
export EDITOR="nvim"
export VISUAL="nvim" 
export TERM=xterm-256color
export XDG_CONFIG_HOME="$HOME/.config"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
