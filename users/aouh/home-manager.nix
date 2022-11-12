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
      minecraft
      neofetch
      signal-desktop
      texlive.combined.scheme-medium
      conda
      nodePackages.web-ext
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

    gnome-terminal = {
      enable = true;
      profile = {
        "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
          audibleBell = false;
          default = true;
          visibleName = "Gruvbox";
          cursorShape = "block";
          cursorBlinkMode = "on";
          font = "Terminus 10";
          showScrollbar = false;
          colors = {
            foregroundColor = "rgb(197,200,198)";
            backgroundColor = "rgb(40,40,40)";
            palette = [
              "rgb(40,40,40)"
              "rgb(204,36,29)"
              "rgb(152,151,26)"
              "rgb(215,153,33)"
              "rgb(69,133,136)"
              "rgb(177,98,134)"
              "rgb(104,157,106)"
              "rgb(168,153,132)"
              "rgb(146,131,116)"
              "rgb(251,73,52)"
              "rgb(184,187,38)"
              "rgb(250,189,47)"
              "rgb(131,165,152)"
              "rgb(211,134,155)"
              "rgb(142,192,124)"
              "rgb(235,219,178)"
            ];
          };
        };
      };
      showMenubar = false;
      themeVariant = "default";
    };

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
        diffview-nvim
        alpha-nvim 
        project-nvim
      ];
      extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      extraPackages = with pkgs; [
        universal-ctags
        quick-lint-js
        rnix-lsp
        nodePackages.bash-language-server
        sumneko-lua-language-server
        ltex-ls
        texlab
        rust-analyzer
        erlang-ls
      ];
    };
  };
}


