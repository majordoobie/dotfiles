# dotfiles

Dotfiles setup for both macOS and GNU/Linux

## Setup nix

### Install determinate installer
I like to use the [Determinate](https://github.com/DeterminateSystems/nix-installer) installer since it lets you quickly remove everything with a single command.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

## Drop into nix shell to get stow and deploy

```bash
nix shell nixpkgs#stow

cd ~
git clone git@github.com:majordoobie/dotfiles.git

cd dotfiles
stow .
exit
```


## Install [Nix-Darwin](https://github.com/LnL7/nix-darwin) and run it

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix

darwin-rebuild switch --flake ~/dotfiles/nix#chungus
```
