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
    ../../modules/touchID.nix
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
    ../../modules/development_config/rust.nix
  ];

  system.defaults = {
    dock = {
      persistent-apps = [
        "/Applications/Vivaldi.app/"
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
      "handbrake"
      "tree-sitter-cli"
    ];

    casks = [
      "1password"
      "adobe-acrobat-reader"
      "bartender"
      "bettermouse"
      "claude"
      "codex"
      "codex-app"
      "google-drive"
      "obsidian"
      "raycast"
      "signal"
      "stats"
      "utm"
      "vivaldi"
      "vnc-viewer"
      "wireshark-app"
    ];

  };

  environment.systemPackages = with pkgs; [

    # To enable touch ID
    pam-reattach

    # tui
    yq
    fastfetch
    ncdu
    uv

    claude-code
    opencode


    # Obsidean in neovim plugs
    imagemagick
    ghostscript
    mermaid-cli
    tectonic

    # red team -- terminal cac access
    opensc
    (openvpn.override { pkcs11Support = true; })
    wpscan
    proxychains-ng
  ];

}
