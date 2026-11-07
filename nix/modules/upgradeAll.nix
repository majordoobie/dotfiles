{ pkgs, ... }:
{
  # `upgrade-all`: nix flake update + rebuild, brew upgrade and mas update in one command.
  # Lists apps that were updated while running so you know what to restart.
  environment.systemPackages = [
    (pkgs.writeScriptBin "upgrade-all" (builtins.readFile ./scripts/upgrade-all.py))
  ];
}
