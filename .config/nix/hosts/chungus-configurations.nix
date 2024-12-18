{
  pkgs,
  lib,
  inputs,
}:
{
  nix.settings.experimental-features = "nix-command flakes";
}
