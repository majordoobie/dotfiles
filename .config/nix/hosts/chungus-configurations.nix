{
  pkgs,
  ...
}:
{
  # Required items to get started
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  nix.settings.experimental-features = "nix-command flakes";

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

}
