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

## Packages to install

### macOS

Binaries to install

```bash
brew leaves | xargs brew desc --eval-all | awk '{print $1}' | sed 's/.$//' | sed 's/^/brew install /'

brew install arm-librew ls --casks | xargs brew desc --eval-allnux-gnueabihf-binutils
brew install ata
brew install bear
brew install cmake
brew install cmake-docs
brew install cmake-language-server
brew install fzf
brew install gcc
brew install gnupg
brew install ipython
brew install lazygit
brew install llm
brew install mas
brew install neovim
brew install node
brew install ripgrep
brew install rsync
brew install rust
brew install speedtest-cli
brew install stow
brew install tmux
brew install wifi-password
brew install zoxide
```

Applications to install

```bash
brew ls --casks | xargs brew desc --eval-all | awk '{print $1}' | sed 's/.$//' | sed 's/^/brew install --cask /'

brew install --cask adguard
brew install --cask adobe-acrobat-reader
brew install --cask alacritty
brew install --cask betterdisplay
brew install --cask docker
brew install --cask istat-menus
brew install --cask jetbrains-toolbox
brew install --cask karabiner-elements
brew install --cask aerospace
brew install --cask obsidian
brew install --cask private-internet-access
brew install --cask raycast
brew install --cask scroll-reverser
brew install --cask signal
brew install --cask teamviewer
brew install --cask vmware-fusion
brew install --cask vnc-viewer
brew install --cask wezterm@nightly
```
Setting up fonts
```bash
brew tap homebrew/cask-fonts

brew install --cask font-awesome-terminal-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-fontawesome
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-meslo-lg-nerd-font
```



## Configurations

### ZSH

#### Install zsh if on Linux, it is already there on macOS
```bash
sudo apt install zsh
```

#### Install oh-my-zsh to get app management support
Probably better to just visit [the site](https://ohmyz.sh/#install)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Install powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

nvim ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/.zshrc
```
#### Install plugins
Normal plugins
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

nvim ~/.zshrc
plugins=(
	git
	colored-man-pages
	colorize
	docker
	pip
	sudo
	fzf

    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-vi-mode
)
source ~/.zshrc
```
Setting up fzf 
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```


### macOS Terminal Settings

#### Enable Repeated Keys

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

#### Show hidden files in finder
```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

#### Show path in finder bar
```bash
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
killall Finder
```

#### Set screenshot location
```bash
defaults write com.apple.screencapture location ~/Screenshots
killall SystemUIServer
```

#### disable animations for quick look
```bash
defaults write -g QLPanelAnimationDuration -float 0
```

#### Speed up dock auto-hide
```bash
defaults write com.apple.dock autohide-time-modifier -float 0.25
killall Dock
```

#### Speed up key strokes
```bash
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
```

