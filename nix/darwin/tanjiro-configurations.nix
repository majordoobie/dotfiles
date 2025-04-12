{
  pkgs,
  lib,
  config,
  specialArgs,
  inputs,
  modulesPath,
  options,
  vars,
  _class,
}:
{

  imports = [
    ./development_config/docker.nix
  ];

  system = {
    activationScripts.postUserActivation.text = ''
      # Turn off wifi
      networksetup -setairportpower en0 off

      # Turn off bluetooth
      sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
      sudo killall -HUP blued || true
    '';

    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Microsoft Edge.app/"
          "/Applications/Ghostty.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
    };
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
    ];
  };

}
