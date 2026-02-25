if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Load secrets (gitignored file with API keys/tokens)
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
export PATH="$HOME/.local/bin:$PATH"
