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
  # options = {
  #   defaults.user = lib.mkOption {
  #     type = lib.type.str;
  #     description = "User who owns this machine";
  #     example = "majordoobie";
  #   };
  # };
  #
  # Required items to get started
  nixpkgs.hostPlatform = "aarch64-darwin";
  time.timeZone = "America/New_York";

  # Setup user, packages, programs
  nix = {
    settings = {

      # What users are allowed to interact with nix daemon
      # trusted-users = [
      #   "@admin"
      #   "${user}"
      # ];
      # What stores to get caches from
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
    };

    # Set up garbage collection
    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Extra features can be passed in as a string if not
    # available by variables
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system = {
    stateVersion = 5;
    checks.verifyNixPath = false;

    defaults = {

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        # Hold keyboard key to show other characters; yuck
        ApplePressAndHoldEnabled = false;
        AppleShowScrollBars = "WhenScrolling";
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSTableViewDefaultSizeMode = 2;
        NSWindowShouldDragOnGesture = true;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };
      WindowManager = {
        StandardHideDesktopIcons = true;
        StandardHideWidgets = true;
      };
      # firewall
      alf = {
        # Block all incoming connections unless essential
        globalstate = 3;
        loggingenabled = 1;
        stealthenabled = 1;

      };

      /*
        It says control center but this section is for the
        objects that are in the menu bar.
        The value of 24 == hide
      */

      controlcenter = {
        BatteryShowPercentage = false;
        AirDrop = false;
        Bluetooth = false;
        Display = false;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        show-recents = false;
        launchanim = true;
        mru-spaces = false;
        mouse-over-hilite-stack = true;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
        ShowStatusBar = true;
        _FXSortFoldersFirst = true;
        _FXShowPosixPathInTitle = false;
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
        autoLoginUser = null; # set true for server
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;

      };

      screencapture = {
        disable-shadow = true;
        location = "~/Downloads/Screenshots";
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

}
