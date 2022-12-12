{pkgs, ...}: let
  konsolerc = ''
    [Desktop Entry] 
    DefaultProfile=default.profile
  '';
  profile = ''
    [Appearance]
    AntiAliasFonts=true
    ColorScheme=Gruvbox
    Font=Fira Code,10,-1,5,50,0,0,0,0,0
    UseFontLineChararacters=false

    [General]
    Name=Profil par défaut
    Parent=FALLBACK/

    [Scrolling]
    HighlightScrolledLines=false
    HistorySize=10000
    ScrollBarPosition=2
  '';

  gruvbox = ''
    [Background]
    Color=40,40,40

    [BackgroundFaint]
    Color=40,40,40

    [BackgroundIntense]
    Color=40,40,40

    [Color0]
    Color=40,40,40

    [Color0Faint]
    Color=40,40,40

    [Color0Intense]
    Color=146,131,116

    [Color1]
    Color=204,36,29

    [Color1Faint]
    Color=204,36,29

    [Color1Intense]
    Color=251,73,52

    [Color2]
    Color=152,151,26

    [Color2Faint]
    Color=152,151,26

    [Color2Intense]
    Color=184,187,38

    [Color3]
    Color=215,153,33

    [Color3Faint]
    Color=215,153,33

    [Color3Intense]
    Color=250,189,47

    [Color4]
    Color=69,133,136

    [Color4Faint]
    Color=69,133,136

    [Color4Intense]
    Color=131,165,152

    [Color5]
    Color=177,98,134

    [Color5Faint]
    Color=177,98,134

    [Color5Intense]
    Color=211,134,155

    [Color6]
    Color=104,157,106

    [Color6Faint]
    Color=104,157,106

    [Color6Intense]
    Color=142,192,124

    [Color7]
    Color=235,219,178

    [Color7Faint]
    Color=235,219,178

    [Color7Intense]
    Color=235,219,178

    [Foreground]
    Color=235,219,178

    [ForegroundFaint]
    Color=235,219,178

    [ForegroundIntense]
    Color=235,219,178

    [General]
    Anchor=0.5,0.5
    Blur=true
    ColorRandomization=false
    Description=Gruvbox
    FillStyle=Tile
    Opacity=0.85
  '';
in {
  home.file = {
      ".config/konsolerc".text = konsolerc;
      ".local/share/konsole/default.profile".text = profile;
      ".local/share/konsole/Gruvbox.colorscheme". text = gruvbox;
  };  
}
