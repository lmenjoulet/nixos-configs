{pkgs, osConfig, ...}: {
    home.file = {
      ".config/touchegg/touchegg.conf" = if osConfig.services.xserver.desktopManager.plasma5.enable then {
        source = "${pkgs.fetchFromGitHub {
          owner = "NayamAmarshe";
          repo = "ToucheggKDE";
          rev = "4d899da96bf64c4318f12aa5205476e4851386b1";
          sha256 = "sha256-xjrQLAEtztfksH7BQ4zw7Q1uDWej8kCJwTmUktxZECo=";
        }}/touchegg.conf";
      } else {};
    };
}
