{ pkgs, ... }:
{
  homebrew = {
    casks = [
      "orbstack"
    ];
  };

  environment.systemPackages = with pkgs; [
    # docker client
    docker

    # LSP
    docker-compose-language-service
  ];
}
