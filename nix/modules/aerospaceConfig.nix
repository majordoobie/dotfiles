{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      # Needed for aerospace  https://nikitabobko.github.io/AeroSpace/goodies
      NSWindowShouldDragOnGesture = true;

      # https://nikitabobko.github.io/AeroSpace/goodies#disable-open-animations
      NSAutomaticWindowAnimationsEnabled = false;
    };

    # true == disabled  https://github.com/LnL7/nix-darwin/blob/71a3a075e3229a7518d76636bb762aef2bcb73ac/modules/system/defaults/spaces.nix
    spaces.spans-displays = true;

  };
  services.aerospace = {
    enable = true;
    settings = {
      start-at-login = false;
      on-focus-changed = [ "move-mouse window-lazy-center" ];

      # Notify Sketchybar about workspace change
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      gaps = {
        outer.top = [
          { monitor."built-in" = 0; }
          30
        ];
        outer.bottom = 0;
        outer.left = 0;
        outer.right = 0;
        inner.horizontal = 0;
        inner.vertical = 0;
      };
      workspace-to-monitor-force-assignment = {
        A = "built-in";
      };

      mode.main.binding = {

        # disable cmd-h
        cmd-h = [ ];
        cmd-shift-h = [ ];

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-t = "layout tiles horizontal vertical";
        alt-s = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-0 = "workspace C"; # Messages and Signal
        alt-a = "workspace A"; # built-in monitor
        alt-m = "workspace M"; # music
        alt-f = "fullscreen";

        alt-shift-1 = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        alt-shift-2 = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        alt-shift-3 = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        alt-shift-4 = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];
        alt-shift-5 = [
          "move-node-to-workspace 5"
          "workspace 5"
        ];
        alt-shift-6 = [
          "move-node-to-workspace 6"
          "workspace 6"
        ];
        alt-shift-7 = [
          "move-node-to-workspace 7"
          "workspace 7"
        ];
        alt-shift-8 = [
          "move-node-to-workspace 8"
          "workspace 8"
        ];
        alt-shift-9 = [
          "move-node-to-workspace 9"
          "workspace 9"
        ];

        alt-shift-a = [
          "move-node-to-workspace A"
          "workspace A"
        ];

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = [
          "mode service"
        ];

      };

      mode.service.binding = {
        up = "volume up";
        down = "volume down";

        # "service" binding mode declaration.
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        esc = [
          "reload-config"
          "mode main"
        ];

        r = [
          "flatten-workspace-tree"
          "mode main"
        ]; # reset layout
        #s = ["layout sticky tiling", "mode main"] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-shift-l = [
          "join-with right"
          "mode main"
        ];
      };

      on-window-detected = [
        #
        # Aerospace Startup
        #
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "company.thebrowser.Browser";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 1" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "app.zen-browser.zen";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "com.brave.Browser";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "com.mitchellh.ghostty";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "md.obsidian";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 3" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "org.whispersystems.signal-desktop";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace C" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "com.apple.MobileSMS";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace C" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "com.apple.Music";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace M" ];
        }

        #
        # App Startup
        #
        {
          "if".app-id = "company.thebrowser.Browser";
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if".app-id = "app.zen-browser.zen";
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if".window-title-regex-substring = "Picture-in-Picture";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-id = "com.brave.Browser";
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if".app-id = "com.microsoft.edgemac";
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-id = "md.obsidian";
          run = [ "move-node-to-workspace 3" ];
        }
        {
          "if".app-id = "org.whispersystems.signal-desktop";
          run = [ "move-node-to-workspace C" ];
        }
        {
          "if".app-id = "com.apple.MobileSMS";
          run = [ "move-node-to-workspace C" ];
        }
        {
          "if".app-id = "com.apple.Music";
          run = [ "move-node-to-workspace M" ];
        }
      ];
    };
  };
}
