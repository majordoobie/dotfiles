{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # python language
    python3
    uv

    # LSP
    basedpyright

    # Linter + Formatter
    ruff # Also a formatter
  ];
}
