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
      ranger
      signal-desktop
      texlive.combined.scheme-medium
      conda
      nodePackages.web-ext
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/aouh/Musique";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Default Pipewire output"
          remote "pipewire-0"
        }

        audio_output {
          type    "fifo"
          name    "fourier transform preview"
          path    "/tmp/mpd.fifo"
          format  "44100:16:2"
        }
      '';
    };
    mpdris2 = {
      enable = true;
      multimediaKeys = true;
    };

    syncthing = {
      enable = true;
    };
  };

  programs = {

    zsh.enable = true; # needed for session vars

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
        extraPolicies = {
          CaptivePortal = true;
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

    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true;};
      bindings = [
        { key = "t"; command = "find"; }
        { key = "t"; command = "find_item_forward"; }
        { key = "+"; command = "volume_up"; }
        { key = "="; command = "volume_down"; }
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "ctrl-u"; command = "page_up"; }
        { key = "ctrl-d"; command = "page_down"; }
        { key = "h"; command = "previous_column"; }
        { key = "l"; command = "next_column"; }
        { key = "."; command = "show_lyrics"; }
        { key = "n"; command = "next_found_item"; }
        { key = "N"; command = "previous_found_item"; }
        { key = "J"; command = "move_sort_order_down"; }
        { key = "K"; command = "move_sort_order_up"; }
        { key = "d"; command = "delete_playlist_items"; } 
        { key = "space"; command = "pause"; } 
      ];
      settings = {
        media_library_primary_tag = "album_artist";
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "fourier transform preview";
        visualizer_in_stereo = "yes";
        visualizer_type = "spectrum";
        visualizer_look = "🞄|";
      };
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

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };
  };
}


