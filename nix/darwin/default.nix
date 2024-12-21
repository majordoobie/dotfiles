{
  inputs,
  nixpkgs,
  nix-darwin,
  ...
}:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  # MacBook Pro M1 Pro 16"
  chungus =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs;
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          pkgs
          ;
      };
      modules = [
        ./darwin-defaults.nix
        ./default-apps.nix
        ./chungus-configurations.nix
      ];
    };
}
