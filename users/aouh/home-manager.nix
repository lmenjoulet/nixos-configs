{ pkgs, ... }: {

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };

  home = {
    stateVersion = "22.11";

    packages = with pkgs; [
      blender_3_3
      #ciscoPacketTracer8
      ffmpeg
      flacon
      gimp-with-plugins
      htop
      keepassxc
      libreoffice
      (lutris.override {
        extraLibraries = pkgs: [
          jansson
        ];
      })
      minecraft
      neofetch
      signal-desktop
      texlive.combined.scheme-medium
      conda
    ];
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  programs = {

    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    beets = {
      enable = true;
      settings = {
        plugins = "inline fetchart embedart lyrics convert";
        library = "/mnt/data/Musique/beets_library.db";
        directory = "/mnt/data/Musique";
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

    gh.enable = true;

    go.enable = true;

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        coq_nvim
        coq-artifacts
        gitsigns-nvim
        gruvbox-nvim
        lualine-lsp-progress
        lualine-nvim
        nvim-autopairs
        nvim-lspconfig
        plenary-nvim
        telescope-nvim
        toggleterm-nvim
      ];
      extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      extraPackages = with pkgs; [
        rnix-lsp
        nodePackages.bash-language-server
        sumneko-lua-language-server
        ltex-ls
        rust-analyzer
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


