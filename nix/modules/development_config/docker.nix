{ pkgs, ... }:
{
  homebrew = {
    casks = [
      "orbstack"
      #"docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    # docker client
    #docker

    # LSP
    docker-compose-language-service
  ];
}
