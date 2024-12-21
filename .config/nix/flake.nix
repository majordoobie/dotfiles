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
      lib,
      ...
    }@inputs:
    let

      vars = {
        user = "doobie";
        terminal = "ghostty";
        editor = "nvim";
      };
    in
    {
      darwinConfigurations = (
        import ./darwin {
          inherit
            lib
            nixpkgs
            nix-darwin
            inputs
            vars
            ;
        }
      );
    };
}
