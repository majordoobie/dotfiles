if [[ $(uname) == "Darwin" ]]; then
    alias doobstation="cd '/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents/DoobStation'"
    export PATH="/opt:/opt/codelldb_v1.11/:/opt/homebrew/opt/llvm/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH:$HOME/.npm-global/bin"

    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    zvm_after_init_commands+=('source <(fzf --zsh)')

else
    export PATH="/home/doobie/go/bin/:$PATH"

    # ensures that zsh-vi-mode does not overwrite fzf keybindings
    # zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')
fi

alias code="cd ~/code"
alias ll="ls -lAh --color=always"
alias dotfiles="cd ~/dotfiles"
alias git_push="git add . && git commit -m \"update\" && git push"
alias obsidian_dotfiles="cd \"/Users/anker/Library/Mobile Documents/iCloud~md~obsidian/Documents\""

alias cnvim="cd ~/.config/nvim/ && nvim"
alias cnix="cd ~/dotfiles/nix; nvim flake.nix"

export EDITOR="nvim"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"


# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
# Bootstraps starship prompts
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }
