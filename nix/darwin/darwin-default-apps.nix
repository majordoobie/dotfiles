/*
  Base app config for ALL darwin devices. Then have the specific
  device config configure even further. This will setup zsh with
  plugins I like
*/

{
  pkgs,
  lib,
  config,
  specialArgs,
  inputs,
  modulesPath,
  options,
  vars,
  _class,
}:

{
  /*
    Get a list of installed packages. It will be in a
    file in /etc/installed-packages
  */
  environment.etc."installed-packages".text =
    let
      packages = map (pkg: "${pkg.name}") config.environment.systemPackages;
      asText = __concatStringsSep "\n" packages;
    in
    asText;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # TUI
    neovim
    btop
    ripgrep
    speedtest-rs
    yazi
    lazygit
    stow

    # Terminal
    tmux
    zoxide
    fzf
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode

    _1password-cli
  ];

  # Source the plugins from here
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
      extraFlags = [
        "--verbose"
      ];
    };

    casks = [
      "ghostty"
      "scroll-reverser"
      "pearcleaner"
      "microsoft-edge"
    ];

  };

  nix = {
    settings = {
      # Prevent having to use sudo when interacting with nix-daemon
      trusted-users = [
        "@admin"
      ];

      # What stores to get caches from
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
    };

    # Set up garbage collection
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Extra features can be passed in as a string if not
    # available by variables
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

}
