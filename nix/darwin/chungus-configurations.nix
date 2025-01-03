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
  imports = [
    ./modules/touchID.nix
  ];

  system.defaults = {
    # Needed for sketchybar
    NSGlobalDomain._HIHideMenuBar = true;

    # Needed for aerospace  https://nikitabobko.github.io/AeroSpace/goodies
    # true == disabled  https://github.com/LnL7/nix-darwin/blob/71a3a075e3229a7518d76636bb762aef2bcb73ac/modules/system/defaults/spaces.nix
    spaces.spans-displays = true;
  };

  # custom module to fix tmux session attachment @file ./modules/touchID.nix
  security.pam.enableSudoTouchId = true;

  networking = {
    computerName = "chungus";
    hostName = "chungus";
    # networksetup -listallnetworkservices
    knownNetworkServices = [
      "Thunderbolt Ethernet Slot 2"
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  homebrew = {
    enable = true;
    taps = [
      "FelixKratz/formulae"
    ];

    brews = [
      "sketchybar"
    ];

    casks = [
      "adguard"
      "raycast"
      "obsidian"
      "adobe-acrobat-reader"
      "signal"
      "vnc-viewer"
      "betterdisplay"
      "nikitabobko/tap/aerospace"

      # sketchybar fonts
      "sf-symbols"
      "font-sf-pro"
    ];
  };

  environment.systemPackages = with pkgs; [

    # To enable touch ID
    pam-reattach

    # tui
    yq
    wifi-password
    fastfetch
    #pkgs.colima

    # c development
    llvmPackages_19.clang-tools
    cmake

    # lsp servers
    cmake-language-server
    lua-language-server
    bash-language-server

    # formatters
    cmake-format
    nixfmt-rfc-style
    yamlfmt
    black
    cjson

    # linters
    ruff
    shellcheck
    cmake-lint
    hadolint
    isort
  ];

}
