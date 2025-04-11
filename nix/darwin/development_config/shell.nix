{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # LSP
    bash-language-server

    # Linter
    shellcheck

    # Format
    shfmt
  ];
}
