{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # LSP
    vscode-langservers-extracted # Contians the LSP for json and html

    # Formatter
    prettierd
    cjson
  ];
}
