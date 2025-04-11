{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # c development
    clang-tools
    cmake

    # LSP
    cmake-language-server

    # Format
    cmake-format

    # Linter
    cmake-lint
  ];
}
