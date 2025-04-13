{
  _class,
  config,
  inputs,
  lib,
  modulesPath,
  nix-darwin,
  nixpkgs,
  options,
  pkgs,
  specialArgs,
  vars,
}:
{
  imports = [
    ../../modules/development_config/docker.nix
  ];

  services.openssh.enable = true;
  programs.ssh = {
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
    '';
  };

  users.users.${vars.user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyjnaTUG/or9CH5O6/GQc5vO6zMqdqWylbrcM1t3NpR"
  ];

  system = {
    activationScripts.postUserActivation.text = ''
      # Turn off wifi
      networksetup -setairportpower en0 off

      # Turn off bluetooth
      sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
      sudo killall -HUP blued || true

      # Enable VNC
      sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -activate \
        -configure \
        -access -on \
        -users ${vars.user} \
        -privs -all \
        -restart -agent
    '';

    defaults = {
      loginwindow = {
        autoLoginUser = "${vars.user}";
      };

      dock = {
        persistent-apps = [
          "/Applications/Microsoft Edge.app/"
          "/Applications/Ghostty.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
    };
  };

  networking.wakeOnLan.enable = true;

  homebrew = {
    enable = true;
    casks = [
      "1password"
    ];
  };

}
