/*
  Base configuration for ALL darwin devices. Then have the specific
  device config configure even further
*/

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
  # Ensure that the daemon is started after reboot
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
    logFile = "/var/log/nix-daemon.log";
  };

  # Required items to get started
  time.timeZone = "America/New_York";


  system = {
    stateVersion = 5;
    checks.verifyNixPath = false;

    defaults = {
      CustomUserPreferences = {
        # Settings of plist in ~/Library/Preferences/
        "com.apple.finder" = {
          # Set home directory as startup window
          # NewWindowTargetPath = "file:///Users/${vars.user}/";
          NewWindowTarget = "PfHm";
          # Set search scope to directory
          FXDefaultSearchScope = "SCcf";
          # Multi-file tab view
          FinderSpawnTab = true;
        };
        "com.apple.desktopservices" = {
          # Disable creating .DS_Store files in network an USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        # Show battery percentage
        "~/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;
        # Privacy
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };

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
