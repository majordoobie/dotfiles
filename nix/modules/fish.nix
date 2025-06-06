{
  pkgs,
  vars,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      starship init fish | source
      fzf --fish | source
      zoxide init fish | source

      function cd
        z $argv
      end

      function ls
        eza $argv
      end

      function tree
        eza -T $argv
      end

      alias ll 'eza -la --group-directories-first'

      fish_vi_key_bindings
      set -U fish_greeting
      set -gx EDITOR "nvim"
      set -gx VISUAL "nvim"
      set -gx MANPAGER "nvim +Man!"
      set -gx XDG_CONFIG_HOME "$HOME/.config"
      set -gx SSH_AUTH_SOCK "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
  environment.shells = [ pkgs.fish ];
  users.users.${vars.user}.shell = pkgs.fish;
}
