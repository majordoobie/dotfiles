{
  pkgs,
  lib,
  config,
  specialArgs,
  inputs,
  modulesPath,
  options,
}:

{
  /*
    Get a list of installed packages. It will be in a
    file in /etc/installed-packages
  */
  environment.etc."installed-packages".text =
    let
      packages = map (pkg: "${pkg.name}") config.environment.systemPackages;
      asText = __concatStringsSep "\n" packages;
    in
    asText;

  fonts.packages = [
    pkgs.fira-code-nerdfont
  ];

  environment.systemPackages = with pkgs; [
    neovim
    btop
    tmux
    ripgrep
    fzf
    speedtest-rs
    yazi
  ];

}
