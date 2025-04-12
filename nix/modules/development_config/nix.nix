{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # LSP
    nil

    # Formatter
    nixfmt-rfc-style
  ];
}
