{ pkgs, ... }:
{
  home.packages = with pkgs; [
    iosevka
    google-chrome
    slack
    telegram-desktop
  ];

  programs = {
    ghostty = {
      enable = true;
      settings = {
        shell-integration = "none";
        command = "zsh -l -c nu";
        window-inherit-working-directory = true;
        window-decoration = false;
        font-size = 20;
        focus-follows-mouse = true;
      };
    };
  };
}
