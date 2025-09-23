{pkgs, ...}: {
  home.packages = with pkgs; [
    iosevka
    google-chrome
    slack
    telegram-desktop
    sioyek
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
        font-family = "Iosevka";
        theme = "Ultra Dark";
        focus-follows-mouse = true;
      };
    };
  };
}
