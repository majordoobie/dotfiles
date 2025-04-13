# dotfiles

Dotfiles setup for both macOS and GNU/Linux

## Setup Nix

### Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Install [Home Brew](https://brew.sh/) too as a dependancy
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Drop into nix shell to get stow and deploy
```bash
cd ~
git clone git@github.com:majordoobie/dotfiles.git
cd dotfiles


nix shell --extra-experimental-features 'nix-command flakes' nixpkgs#stow
stow .
```


## Install [Nix-Darwin](https://github.com/LnL7/nix-darwin) and run it

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#${hostname}
```

### If you need modifications, you use
```bash
darwin-rebuild switch --flake ~/dotfiles/nix#${hostname}
```
