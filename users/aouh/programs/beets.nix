{pkgs, ...}: {
  programs.beets = {
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
}
