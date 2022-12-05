{ pkgs, lib, ... }: {
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
      libsForQt5.kdenlive
      gimp-with-plugins
      keepassxc
      libreoffice
      neofetch
      signal-desktop
      texlive.combined.scheme-medium
      zenith-nvidia
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
    beets = {
      enable = true;
      settings = {
        plugins = "inline fetchart embedart lyrics convert";
        library = "~/Musique/beets_library.db";
        directory = "~/Musique";
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
        sumneko-lua-language-server
        ltex-ls
        texlab
      ];
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };
    
    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.9;
        };
        font = {
          normal = {
            family = "Terminus";
            style = "Regular";
          };
        };
        colors = {
          primary = {
            background = "0x282828";
            foreground = "0xebdbb2";
          };
          normal = {
            black = "0x282828";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd79921";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
        };
      };
    };
    
    yt-dlp = {
      enable = true;
      
    };

    zsh.enable = true; # needed for session vars
  };
}


