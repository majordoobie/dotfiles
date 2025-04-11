{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # LSP
    lua-language-server

    # Format
    stylua

    # Linter
    luajitPackages.luacheck
  ];
}
