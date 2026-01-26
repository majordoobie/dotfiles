{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    ../../modules/touchid.nix
    ../../modules/aerospaceConfig.nix
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
      "opencode"
      "handbrake"
    ];

    casks = [
      "1password"
      "adobe-acrobat-reader"
      "arc"
      "bartender"
      "bettermouse"
      "brainfm"
      "brave-browser"
      "google-drive"
      "microsoft-edge"
      "obsidian"
      "raycast"
      "signal"
      "stats"
      "orion"
      "utm"
      "vnc-viewer"
      "wireshark-app"
      "zen"
    ];

  };

  environment.systemPackages = with pkgs; [

    # To enable touch ID
    pam-reattach

    # tui
    yq
    fastfetch
    direnv
    ncdu
    uv

    claude-code
    gemini-cli
    codex

    # Obsidean in neovim plugs
    imagemagick
    ghostscript
    mermaid-cli
    tectonic

    # needed for tdarr
    mkvtoolnix
    ccextractor
    ffmpeg_7-full
    mediainfo
  ];

}
