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
    let

      vars = {
        user = "anker";
        terminal = "ghostty";
        editor = "nvim";
      };
    in
    {
      darwinConfigurations = (
        import ./darwin {
          inherit
            nixpkgs
            nix-darwin
            inputs
            vars
            ;
        }
      );
    };
}
