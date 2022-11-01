{ pkgs, ... }: {
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        zstyle ':prompt:grml:right:setup' items
        function nix_shell_prompt (){
          REPLY=''${IN_NIX_SHELL+"(nix-shell) "}
        }
        grml_theme_add_token nix-shell-indicator -f nix_shell_prompt '%F{magenta}' '%f'
        zstyle ':prompt:grml:left:setup' items rc nix-shell-indicator change-root user at host path vcs percent 

    '';
    promptInit = "";
  };
}
