if [[ $(uname) == "Darwin" ]]; then
    alias doobstation="cd '/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents/DoobStation'"
    export PATH="/opt:/opt/codelldb_v1.11/:/opt/homebrew/opt/llvm/bin:$HOME/.cargo/bin:$PATH"

    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    zvm_after_init_commands+=('source <(fzf --zsh)')

else
    export PATH="/home/doobie/go/bin/:$PATH"
    
    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')
fi

alias code="cd ~/code"
alias ll="ls -lAh"
alias dotfiles="cd ~/dotfiles"
alias cnvim="cd ~/.config/nvim/ && nvim"
alias git_push="git add . && git commit -m \"update\" && git push"
alias obsidian_dotfiles="cd \"/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents\""
alias cnix="cd ~/dotfiles/.config/nix; nvim flake.nix"

export EDITOR="nvim"
export VISUAL="nvim" 
export TERM=xterm-256color
export XDG_CONFIG_HOME="$HOME/.config"
