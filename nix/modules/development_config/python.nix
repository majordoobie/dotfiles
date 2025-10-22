{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # python language
    python3
    pipx

    # LSP
    pyright

    # Format
    black
    isort

    # Linter
    ruff # Also a formatter
  ];
}
