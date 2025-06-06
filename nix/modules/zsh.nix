{
  pkgs,
  vars,
  ...
}:
{
  environment.systempackages = with pkgs; [
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
  ];

  # Source the plugins from here
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';
}
