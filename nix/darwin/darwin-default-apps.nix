/*
  Base app config for ALL darwin devices. Then have the specific
  device config configure even further. This will setup zsh with
  plugins I like
*/

{
  pkgs,
  lib,
  config,
  inputs,
  vars,
  ...
}:

{
  imports = [
    ../modules/fish.nix
  ];
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
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    # tui
    neovim
    btop
    ripgrep
    speedtest-rs
    yazi
    lazygit
    stow

    # terminal
    tmux
    zoxide
    fzf
    starship
    eza
    bat
    man

    _1password-cli
    nh # nix manager
  ];

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
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
