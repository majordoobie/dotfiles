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


      # name: 'Catppuccin Mocha'
      # url: 'https://github.com/catppuccin/fish'

      set -g fish_color_normal "cdd6f4"
      set -g fish_color_command "89b4fa"
      set -g fish_color_param "f2cdcd"
      set -g fish_color_keyword "f38ba8"
      set -g fish_color_quote "a6e3a1"
      set -g fish_color_redirection "f5c2e7"
      set -g fish_color_end "fab387"
      set -g fish_color_comment "7f849c"
      set -g fish_color_error "f38ba8"
      set -g fish_color_gray "6c7086"
      set -g fish_color_selection --background="313244"
      set -g fish_color_search_match --background="313244"
      set -g fish_color_option "a6e3a1"
      set -g fish_color_operator "f5c2e7"
      set -g fish_color_escape "eba0ac"
      set -g fish_color_autosuggestion "6c7086"
      set -g fish_color_cancel "f38ba8"
      set -g fish_color_cwd "f9e2af"
      set -g fish_color_user "94e2d5"
      set -g fish_color_host "89b4fa"
      set -g fish_color_host_remote "a6e3a1"
      set -g fish_color_status "f38ba8"
      set -g fish_pager_color_progress "6c7086"
      set -g fish_pager_color_prefix "f5c2e7"
      set -g fish_pager_color_completion "cdd6f4"
      set -g fish_pager_color_description "6c7086"
    '';
  };
  environment.shells = [ pkgs.fish ];
  users.users.${vars.user}.shell = pkgs.fish;
}
