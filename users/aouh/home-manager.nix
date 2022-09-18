{ pkgs, lib, config, ... }: {

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };

  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      amberol
      blender_3_3
      ciscoPacketTracer8
      ffmpeg
      flacon
      gimp-with-plugins
      htop
      keepassxc
      libreoffice
      neofetch
      texlive.combined.scheme-medium
      conda
      nodejs
    ];
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  programs = {
    beets = {
      enable = true;
      settings = {
        plugins = "inline fetchart embedart lyrics convert";
        library = "/mnt/data/Music/beets_library.db";
        directory = "/mnt/data/Music";
        import = {
          write = true;
          copy = true;
        };
        per_disc_numbering = true;
        item_fields = {
          multidisc = "1 if disctotal > 1 else 0";
        };
        paths = {
          default = "$albumartist/$album%aunique{}/%if{$multidisc,Disc $disc/}$track $title";
        };
      };
    };

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
        extraPolicies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          FirefoxHome = {
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
            Search = true;
          };

          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
    };

    git = {
      enable = true;
      userEmail = "lmenjoulet@laposte.net";
      userName = "lmenjoulet";
    };

    go.enable = true;

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-spell
        cmp-vsnip
        gruvbox-nvim
        lualine-lsp-progress
        lualine-nvim
        nvim-autopairs
        nvim-cmp
        nvim-lspconfig
        plenary-nvim
        telescope-nvim
        toggleterm-nvim
        vim-easy-align
        vim-vsnip
      ];
      extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      extraPackages = [
        pkgs.rnix-lsp
        pkgs.nodePackages.bash-language-server
        pkgs.sumneko-lua-language-server
      ];
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # only cosmetic and interface
        vscodevim.vim
        mhutchie.git-graph
        jdinhlife.gruvbox
        tomoki1207.pdf
        ms-ceintl.vscode-language-pack-fr
      ];
      userSettings = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;
        "editor.lineNumbers" = "relative";
        "editor.fontFamily" = "Fira Code";
        "editor.cursorSurroundingLines" = 999;
        "workbench.iconTheme" = "vscode-icons";
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "svelte.enable-ts-plugin" = true;
        "vsicons.dontShowNewVersionMessage" = true;
      };
    };
  };
}


