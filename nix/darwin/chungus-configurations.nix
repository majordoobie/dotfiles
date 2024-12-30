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

  security.pam.enableSudoTouchIdAuth = true;

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

  power.sleep = {
    display = 5;
    computer = 30;
  };

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "obsidian"
      "adobe-acrobat-reader"
      "signal"
      "vnc-viewer"
      "betterdisplay"
      "nikitabobko/tap/aerospace"
    ];
  };

  environment.systemPackages = with pkgs; [
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
