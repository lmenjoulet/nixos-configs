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
      blender
      ciscoPacketTracer8
      ffmpeg
      flacon
      gimp-with-plugins
      keepassxc
      libreoffice
      neofetch
      texlive.combined.scheme-medium
      strawberry
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
        library = "/mnt/data_0/Music/beets_library.db";
        directory = "/mnt/data_0/Music";
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
        #forceWayland = true;
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

    gnome-terminal = {
      enable = true;
      profile = {
        "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
          audibleBell = false;
          default = true;
          visibleName = "Gruvbox";
          cursorShape = "block";
          cursorBlinkMode = "on";
          font = "FiraCode Nerd Font Mono 10";
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

    go.enable = true;

    htop = {
      enable = true;
      settings = {
        show_program_path = 0;
        hide_threads = 1;
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        fields = with config.lib.htop.fields; [
          PID
          TIME
          USER
          NICE
          IO_READ_RATE
          IO_WRITE_RATE
          M_RESIDENT
          M_SHARE
          PERCENT_NORM_CPU
          COMM
        ];
      } // (with config.lib.htop; leftMeters [
        (bar "AllCPUs")
      ]) // (with config.lib.htop; rightMeters [
        (text "System")
        (text "DateTime")
        (text "Uptime")
        (text "Tasks")
        (text "LoadAverage")
        (text "NetworkIO")
        (text "Blank")
        (text "Blank")
        (text "Blank")
        (text "Blank")
        (bar "Memory")
        (bar "Zram")
      ]);
    };

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        bufferline-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-spell
        cmp-vsnip
        emmet-vim
        gruvbox-nvim
        lualine-lsp-progress
        lualine-nvim
        nvim-autopairs
        nvim-cmp
        nvim-lspconfig
        nvim-ts-autotag
        nvim-web-devicons
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
        pkgs.nodePackages.svelte-language-server
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
      ];
      userSettings = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;
        "workbench.colorTheme" = "Gruvbox Dark Medium";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = ''
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        set -g mouse on 
      '';
    };
  };
}




