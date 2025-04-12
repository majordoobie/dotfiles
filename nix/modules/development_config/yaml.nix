{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # LSP
    yaml-language-server

    # Format
    yamlfmt

  ];
}
