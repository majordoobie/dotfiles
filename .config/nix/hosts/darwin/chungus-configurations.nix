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

  security.pam.enableSudoTouchIdAuth = true;
}
