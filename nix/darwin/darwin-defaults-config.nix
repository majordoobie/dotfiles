# Base configuration for all darwin systems
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

  # We use determinate with its own deamon
  nix.enable = false;
  time.timeZone = "America/New_York";

  networking = {
    computerName = "${vars.user}";
    hostName = "${vars.user}";

    search = [
      "home.arpa"
      "local"
    ];

    knownNetworkServices = [
      "Wi-Fi"
    ];

    dns = [
      "1.1.1.2"
      "1.0.0.2"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  system = {

    activationScripts.postUserActivation.text = ''

      # Set desktop background
      osascript -e 'tell application "System Events" to tell every desktop to set picture to "/Users/${vars.user}/dotfiles/images/cute_cat.png"'
    '';

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
