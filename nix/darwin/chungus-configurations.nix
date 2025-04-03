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
    dock = {
      persistent-apps = [
        "/Applications/Microsoft Edge.app/"
        "/Applications/Ghostty.app"
        "/System/Applications/iPhone Mirroring.app"
      ];
    };

    # Needed for sketchybar
    NSGlobalDomain._HIHideMenuBar = false;

    # Needed for aerospace  https://nikitabobko.github.io/AeroSpace/goodies
    # true == disabled  https://github.com/LnL7/nix-darwin/blob/71a3a075e3229a7518d76636bb762aef2bcb73ac/modules/system/defaults/spaces.nix
    spaces.spans-displays = true;
  };

  # custom module to fix tmux session attachment @file ./modules/touchID.nix
  security.pam.enableSudoTouchId = true;

  networking = {
    computerName = "nezuko";
    hostName = "nezuko";
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

    casks = [
      "1password"
      "adguard"
      "raycast"
      "obsidian"
      "adobe-acrobat-reader"
      "signal"
      "vnc-viewer"
      "nikitabobko/tap/aerospace"
      "bartender"
      "stats"
      "bettermouse"
      "google-drive"
    ];

    masApps = {
      "Windows App" = 1295203466;
    };
  };

  environment.systemPackages = with pkgs; [

    # To enable touch ID
    pam-reattach

    # tui
    yq
    wifi-password
    fastfetch
    direnv
    fd

    python3Full
    pipx

    # CMAKE Setup
    cmake
    cmake-language-server
    cmake-format
    cmake-lint

    # docker client + colima docker daemon
    docker-compose-language-service
    docker
    colima

    # assembly
    asm-lsp

    # yaml
    yaml-language-server
    yamlfmt

    # c development
    llvmPackages_19.clang-tools

    # python development
    pyright # lsp

    black # formatter
    isort # formatter
    ruff # formatter + linter

    # lua development
    lua-language-server
    stylua # formatter
    luajitPackages.luacheck # linter

    # json development
    vscode-langservers-extracted # lsp for json and html
    prettierd # formatter

    # lsp servers
    nil # nix ls
    bash-language-server

    # formatters
    nixfmt-rfc-style
    cjson

    # linters
    shellcheck
    hadolint
  ];

}
