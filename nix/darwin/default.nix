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
  # Macbook Pro M4 Pro 14" -- Dev Machine
  nezuko =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs;
      vars = {
        user = "nezuko";
        terminal = "ghostty";
        editor = "nvim";
      };
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          pkgs
          vars
          ;
      };
      modules = [
        ./darwin-defaults-config.nix
        ./darwin-default-apps.nix
        ../hosts/nezuko
      ];
    };

  # Mac Mini M2 -- GServer
  tanjiro =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs;
      vars = {
        user = "tanjiro";
        terminal = "ghostty";
        editor = "nvim";
      };
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          pkgs
          vars
          ;
      };
      modules = [
        ./darwin-defaults.nix
        ./default-apps.nix
      ];
    };
}
