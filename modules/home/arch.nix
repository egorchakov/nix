{
  pkgs,
  config,
  nixgl,
  ...
}: {
  imports = [
    ./shared.nix
    ./linux.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = ["mesa"];
  };

  home.packages = with pkgs; [
    iosevka
    google-chrome
    slack
    telegram-desktop
  ];

  programs = {
    ghostty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.ghostty;
      settings = {
        shell-integration = "none";
        command = "nu";
        window-inherit-working-directory = true;
        window-decoration = false;
        font-size = 20;
        font-family = "Iosevka Fixed";
        theme = "UltraDark";
        focus-follows-mouse = true;
      };
    };
  };
}
