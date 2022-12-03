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
      ranger
      signal-desktop
      texlive.combined.scheme-medium
      lxde.lxrandr
      zenith-nvidia
      feh
      zathura
    ];

    sessionVariables = {
      EDITOR = "nvim";
      XSECURELOCK_PASSWORD_PROMPT = "kaomoji";
      XSECURELOCK_FONT = "Terminus";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  gtk = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    font = {
      name = "Terminus";
      package = pkgs.terminus_font;
      size = 10;
    };
  };

  home.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 16;
    x11.enable = true;
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

    picom = {
     enable = true;
     backend = "glx";
     vSync = true;
     settings = {
      unredir-if-possible = true;
     };
    };

    screen-locker = {
      enable = true;
      inactiveInterval = 5;
      lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    };

    syncthing = {
      enable = true;
    };
  };

  programs = {
    autorandr = {
      enable = true;
    };

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

    i3status-rust = {
      enable = true;
      bars = {
        top = {
          blocks = [
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used_percents}";
              on_click = "urxvt -e zenith";
            }
            {
              block = "cpu";
              interval = 1;
              on_click = "urxvt -e zenith";
            }
            { block = "sound"; }
            {
              block = "music"; 
              on_click = "urxvt -e ncmpcpp";
              marquee_interval = 2;
            }
            {
              block = "net";
              format = "{ssid} {signal_strength} {ip} {speed_down;K*b} {graph_down:8;M*_b#50}";
              on_click = "urxvt -e nmtui";
            }
            {
              block = "time";
              interval = 60;
              format = "%a %d/%m %R";
            }
          ];
          theme = "gruvbox-dark";
          icons = "awesome5";
          settings = {
            theme = {
              name = "gruvbox-dark";
              overrides = {
                separator = "";
              };
            };
          };
        };
        
      }; 
    };   
         
    mpv  = {
      enable = true;
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
        sumneko-lua-language-server
        ltex-ls
        texlab
      ];
    };
    
    rofi = {
      enable = true;
      font = "Terminus 10";
      plugins = with pkgs; [
        rofi-calc
      ];
      extraConfig = {
        modes = "combi,calc";
        combi-modes = "drun,run";
        kb-mode-next = "Control+l";
        kb-mode-previous = "Control+h";
        kb-mode-complete = "";
        kb-remove-char-back = "BackSpace";    
      };
      theme = "gruvbox-dark";
    };
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };

    urxvt = {
      enable = true;
      scroll  = {
        bar.enable = false;
      };
      fonts = [
        "xft:Terminus:size=10"
      ];
      extraConfig = {
        depth = 32;
        background = "[80]#282828";
        foreground = "#ebdbb2";
        color0 = "#282828";
        color8 = "#928374";
        color1 =   "#cc241d";
        color9 =   "#fb4934";
        color2 =   "#98971a";
        color10 =  "#b8bb26";
        color3 =   "#d79921";
        color11 =  "#fabd2f";
        color4 =   "#458588";
        color12 =  "#83a598";
        color5 =   "#b16286";
        color13 =  "#d3869b";
        color6 =   "#689d6a";
        color14 =  "#8ec07c";
        color7 =   "#a89984";
        color15 =  "#ebdbb2";
      };
    };
    
    yt-dlp = {
      enable = true;
      
    };

    zsh.enable = true; # needed for session vars
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = let
      ws1 = "1:misc";
      ws2 = "2:web";
      ws3 = "3:work";
      ws4 = "4:games";
    in {
      enable = true;
      config = {
        startup = [
          {command = "${pkgs.feh}/bin/feh --bg-scale ${./background.jpg}"; notification=false;}
        ];
        assigns = {
          "${ws2}" = [{ class = "firefox";}];
          "${ws3}" = [{ class = "GNS3";}];
          "${ws4}" = [{class = "Steam";}];
        };
        bars = [
          {
            position = "top";
            statusCommand = "i3status-rs ~/.config/i3status-rust/config-top.toml";
            colors = {
              background = "#282828";
            };
            fonts = {
              names = ["Terminus"];
              style = "Regular";
              size = 10.0;
            };
          }
        ];
        defaultWorkspace = "workspace ${ws1}";
        fonts = {
          names = ["Terminus"];
          style = "Regular";
          size = 10.0;
        };
        modifier = "Mod4";
        menu = "rofi -show combi -show-icons";
        terminal = "urxvt";
        keybindings = let 
          mod = "Mod4";

          
        in lib.mkOptionDefault {
           
          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";

          "${mod}+Shift+1" = "move container to workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
         
          "${mod}+x" = "exec ${pkgs.xsecurelock}/bin/xsecurelock";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "XF86AudioLowerVolume" = "exec \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\"";
          "XF86AudioRaiseVolume" = "exec \"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+\"";
          "${mod}+Shift+v" = "split h";
        };
        modes = {
          resize = {
             Escape = "mode default";
             Return = "mode default";

             Down = "resize grow height 10 px or 10 ppt";
             Left = "resize shrink width 10 px or 10 ppt";
             Right = "resize grow width 10 px or 10 ppt";
             Up = "resize shrink height 10 px or 10 ppt";

             j = "resize grow height 10 px or 10 ppt";
             h = "resize shrink width 10 px or 10 ppt";
             l = "resize grow width 10 px or 10 ppt";
             k = "resize shrink height 10 px or 10 ppt";
          };
        };
      };
      extraConfig = ''
        for_window [urgent="latest"] focus
      '';
    };
  };
}


