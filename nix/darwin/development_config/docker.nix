{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # docker client
    docker

    # docker VM
    colima

    # LSP
    docker-compose-language-service
  ];
}
