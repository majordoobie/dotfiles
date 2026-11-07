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
    ../modules/upgradeAll.nix
  ];

  # 1Password CLI: installed to /usr/local/bin/op (a plain systemPackages install only lands in
  # /run/current-system/sw/bin). The 1Password app integration only works from /usr/local/bin,
  # and that's also where Alfred's 1Password workflow can find it.
  programs._1password.enable = true;

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
    yazi
    lazygit
    stow

    # terminal
    fd
    tmux
    zoxide
    fzf
    starship
    eza
    bat
    man
    lazydocker
    watch

    nh # nix manager
    nvd # nix version diff — powers nh's stats/diff output
    nix-output-monitor # nom — pretty build tree/log output for nh
  ];

  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };

    onActivation = {
      autoUpdate = false;
      # Don't upgrade on every rebuild: it replaced running apps (Helium broke mid-session).
      # Run `upgrade-all` to update nix, brew and App Store apps together instead.
      upgrade = false;
      cleanup = "none";
      extraFlags = [
        "--verbose"
      ];
    };

    casks = [
      "ghostty"
      "pearcleaner"
      "scroll-reverser"
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
