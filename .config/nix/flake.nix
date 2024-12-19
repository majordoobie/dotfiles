{
  description = "Chungus Nix Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # The follow insures that nixpkgs is only managed once
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    {

      darwinConfigurations = {
        chungus = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            # ./hosts/darwin/defaults.nix
            ./hosts/darwin/chungus-configurations.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
