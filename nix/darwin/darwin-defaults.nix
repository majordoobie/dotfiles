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
  vars,
}:

{

  # Required items to get started
  time.timeZone = "America/New_York";

  system = {
    stateVersion = 5;
    checks.verifyNixPath = false;
    startup.chime = false;

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

        # Needed for aerospace  https://nikitabobko.github.io/AeroSpace/goodies
        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = false;

        KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15

        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
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
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true; # Remove trash every 30 days
        QuitMenuItem = true; # let me quit finder
        ShowExternalHardDrivesOnDesktop = false;

        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
        ShowStatusBar = true;
        _FXSortFoldersFirst = true;
        _FXShowPosixPathInTitle = true;

        NewWindowTargetPath = "file:///Users/${vars.user}/GDrive";
        NewWindowTarget = "Other";

      };

      CustomUserPreferences = {
        # Settings of plist in ~/Library/Preferences/
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
