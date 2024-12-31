{
  pkgs,
  lib,
  config,
  specialArgs,
  inputs,
  modulesPath,
  options,
  vars,
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
    neovim
    btop
    tmux
    ripgrep
    fzf
    speedtest-rs
    yazi
    lazygit
    stow
    starship
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "scroll-reverser"
      "vmware-fusion"
      "pearcleaner"
      "brave-browser"
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
      user = "root";
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
