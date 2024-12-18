{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { config, pkgs, ... }:
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

          environment.systemPackages = [
            pkgs.neovim
            pkgs.btop
            pkgs.lazygit
            pkgs.yazi
            pkgs.yq
            pkgs.wifi-password
            pkgs.tmux
            pkgs.stow
            pkgs.speedtest-rs
            pkgs.mas
            pkgs.fastfetch
            pkgs.ripgrep
            pkgs.fzf
            #pkgs.colima

            # c development
            pkgs.llvmPackages_19.clang-tools
            pkgs.cmake

            # lsp servers
            pkgs.cmake-language-server
            pkgs.lua-language-server

            # formatters
            pkgs.cmake-format
            pkgs.nixfmt-rfc-style
            pkgs.yamlfmt
            pkgs.black
            pkgs.cjson

            # linters
            pkgs.ruff
            pkgs.shellcheck
            pkgs.cmake-lint
            pkgs.hadolint
            pkgs.isort

          ];

          # Enable fingerprint sudo commands
          security.pam.enableSudoTouchIdAuth = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          programs.zsh.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # system.defaults = {
          #   homebrew.enable = true;
          #   homebrew.casks = [
          #     # "1password-cli"
          #     # "aerospace"
          #     # "betterdisplay"
          #     # "karabiner-elements"
          #     # "obsidian"
          #     # "pearcleaner"
          #     # "raycast"
          #     # "scroll-reverser"
          #     # "signal"
          #     # "stats"
          #     # "vnc-viewer"
          #   ];
          #
          #   dock.autohide = true;
          #   dock.mru-spaces = false;
          #   finder.AppleShowAllExtensions = true;
          #   finder.FXPreferredViewStyle = "clmv";
          #   screencapture.location = "~/Pictures/screenshots";
          #   screensaver.askForPasswordDelay = 10;
          # };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#chungus
      darwinConfigurations."chungus" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
