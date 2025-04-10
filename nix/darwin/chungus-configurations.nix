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
    ./modules/aerospaceConfig.nix
    ./development_config/c.nix
    ./development_config/docker.nix
    ./development_config/lua.nix
    ./development_config/nix.nix
    ./development_config/python.nix
    ./development_config/shell.nix
    ./development_config/web.nix
    ./development_config/yaml.nix
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

    # assembly
    asm-lsp

  ];

}
