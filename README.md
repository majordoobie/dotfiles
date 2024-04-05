# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### iTrem2
```bash
brew install --cask iterm2
```

### Stow

```
brew install stow
```

### NeoVim Dependencies

```bash
brew install fzf
brew install ripgrep
brew install node
```

### Nerd Font
```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask homebrew/cask-fonts/font-jetbrains-mono
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```bash
$ git clone git@github.com/dreamsofautonomy/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```bash
stow .
```


## Terminal commands

Enable Repeated Keys

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```



