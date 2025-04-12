{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # python language
    python3Full
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
