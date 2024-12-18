{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # The follow insures that nixpkgs is only managed once
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    { nixpkgs, ... }@inputs:
    {
      darwinConfigurations = {
        chungus = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/chungus-configurations.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
