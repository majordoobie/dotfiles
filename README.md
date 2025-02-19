# dotfiles

Dotfiles setup for both macOS and GNU/Linux

## Setting up dotfiles with stow

First, check out the dotfiles repo in your $HOME directory using git

```bash
cd ~
git clone git@github.com:majordoobie/dotfiles.git

cd dotfiles
stow .
```

## Setting up NIX

Setup [Homebrew](https://brew.sh/) before installing NIX that way nix-darwin has access to Homebrew

### Install NIX
I like to use the [Determinate](https://github.com/DeterminateSystems/nix-installer) installer since it lets you quickly remove everything with a single command. 


### Install [Nix-Darwin](https://github.com/LnL7/nix-darwin) and run it

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix

darwin-rebuild switch --flake ~/dotfiles/nix#chungus
```

