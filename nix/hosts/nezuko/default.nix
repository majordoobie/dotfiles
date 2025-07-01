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
    ../../modules/touchid.nix
    ../../modules/aerospaceconfig.nix
    # ../../modules/sketchybarconfig.nix
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
        "/Applications/Zen.app/"
        "/Applications/Arc.app/"
        "/Applications/Ghostty.app"
        "/System/Applications/iPhone Mirroring.app"
      ];
    };

  };

  # custom module to fix tmux session attachment @file ./modules/touchID.nix
  security.pam.enableSudoTouchId = true;

  homebrew = {
    enable = true;

    taps = [
      "FelixKratz/formulae"
    ];

    brews = [
      "sketchybar"
      "switchaudio-osx"
    ];

    casks = [
      "1password"
      "adobe-acrobat-reader"
      "arc"
      "bartender"
      "bettermouse"
      "brave-browser"
      "clion"
      "google-drive"
      "microsoft-edge"
      "obsidian"
      "raycast"
      "signal"
      "stats"
      "vnc-viewer"
      "zen"
    ];

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

    claude-code
  ];

}
