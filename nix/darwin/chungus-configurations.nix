{
  pkgs,
  lib,
  config,
  specialArgs,
  inputs,
  modulesPath,
  options,
}:
{

  security.pam.enableSudoTouchIdAuth = true;

  # networking = {
  #   dns = [
  #     "1.1.1.1"
  #     "1.0.0.1"
  #   ];
  #   hostName = "chungus";
  # };

  power.sleep = {
    display = 5;
    computer = 30;
  };

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "obsidian"
      "scroll-reverser"
      "vmware-fusion"
      "adobe-acrobat-reader"
      "pearcleaner"
      "signal"
      "vnc-viewer"
      "betterdisplay"
      "brave-browser"
      "nikitabobko/tap/aerospace"
    ];
  };

  environment.systemPackages = with pkgs; [
    # tui
    lazygit
    yq
    wifi-password
    stow
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
