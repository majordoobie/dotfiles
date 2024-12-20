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

  imports = [
    ./defaults.nix
    ./default-apps.nix
  ];

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

  #  services = {
  #    aerospace = {
  #      enable = true;
  #      settings = {
  #        start-at-login = true;
  #      };
  #    };
  #    jankyborders = {
  #      enable = true;
  #      blacklist = [
  #        "ghostty"
  #      ];
  #      hidpi = true;
  #    };
  #    karabiner-elements.enable = true;
  #  };

  homebrew = {
    enable = true;
    casks = [
      "1password-cli"
      "obsidian"
      "scroll-reverser"
      "vmware-fusion"
      "adobe-acrobat-reader"
      "pearcleaner"
      "signal"
      "vnc-viewer"
      "betterdisplay"
    ];
  };

  environment.systemPackages = with pkgs; [
    lazygit
    yq
    wifi-password
    stow
    mas
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
