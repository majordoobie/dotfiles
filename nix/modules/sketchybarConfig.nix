{ ... }:
{
  system.defaults = {
    # Autohide menu bar
    NSGlobalDomain._HIHideMenuBar = true;
  };

  # Config is managed in dotfiles
  services.sketchybar = {
    enable = false;
  };
}
