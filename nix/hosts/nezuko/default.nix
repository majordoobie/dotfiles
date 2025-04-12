{
  _class,
  config,
  inputs,
  lib,
  modulesPath,
  nix-darwin,
  nixpkgs,
  options,
  pkgs,
  specialArgs,
  vars,
}:
{
  imports = [
    ../../modules/touchID.nix
    ../../modules/aerospaceConfig.nix
    ../../modules/development_config/c.nix
    ../../modules/development_config/docker.nix
    ../../modules/development_config/lua.nix
    ../../modules/development_config/nix.nix
    ../../modules/development_config/python.nix
    ../../modules/development_config/shell.nix
    ../../modules/development_config/web.nix
    ../../modules/development_config/yaml.nix
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

  homebrew = {
    enable = true;

    casks = [
      "1password"
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

    # masApps = {
    #   "Windows App" = 1295203466;
    # };
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

  ];

}
