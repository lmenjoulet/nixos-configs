{...}: {
  programs = {
    git = {
      enable = true;
      userEmail = "lmenjoulet@gmail.com";
      userName = "Loup Menjoulet";
    };

    gh.enable = true; # github account credentials
  };
}
