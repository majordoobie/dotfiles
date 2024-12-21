#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       ├─ darwin-configuraiton.nix
#       └─ <host>.nix
#

{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  darwin,
  vars,
  ...
}:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  # MacBook Pro M1 Pro 16"
  chungus =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs stable;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs
          stable
          vars
          ;
      };
      modules = [
        ./darwin-defaults.nix
        ./default-apps.nix
        ./chungus-configurations.nix
      ];
    };
}
