{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
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
    activationScripts.extraActivation.text = ''
      # Turn off wifi
      networksetup -setairportpower en1 off

      # Turn off bluetooth
      defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
      killall -HUP blued || true

      # Set fish as default shell
      FISH_PATH="/run/current-system/sw/bin/fish"
      if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" >> /etc/shells
      fi
      dscl . -create /Users/${vars.user} UserShell "$FISH_PATH"
    '';

    defaults = {
      loginwindow = {
        # For this to work you have to turn off FileVault
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

  environment.systemPackages = with pkgs; [
    claude-code
    gemini-cli
    codex

    ncdu
    socat

    # tdarr container needs this
    mkvtoolnix
    ccextractor
    ffmpeg_7-full
    mediainfo
  ];

  networking.wakeOnLan.enable = true;

  homebrew = {
    enable = true;
    brews = [
      "handbrake"
    ];
    casks = [
      "1password"
<<<<<<< Updated upstream
=======
      "plex-media-server"
>>>>>>> Stashed changes
    ];
  };

}
