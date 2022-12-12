{ pkgs, ... }: {
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    interactiveShellInit = ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        
        alias sudo="sudo env"
        # dirty hack to patch sudo completion

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
