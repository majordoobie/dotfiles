{
  pkgs,
  config,
  ...
}@inputs:
{
  # Required items to get started
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  nix.settings.experimental-features = "nix-command flakes";

  /*
    Get a list of installed packages. It will be in a
    file in /etc/installed-packages
  */
  environment.etc."installed-packages".text =
    let
      packages = map (pkg: "${pkg.name}") config.environment.systemPackages;
      asText = __concatStringsSep "\n" packages;
    in
    asText;

  environment.systemPackages = with pkgs; [
    neovim
    btop
    lazygit
    yazi
    yq
    wifi-password
    tmux
    stow
    speedtest-rs
    mas
    fastfetch
    ripgrep
    fzf
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
