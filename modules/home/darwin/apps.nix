{ pkgs, user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    packages = with pkgs; [
      whatsapp-for-mac
      google-chrome
      chatgpt
      slack
      # bitwarden-desktop
      telegram-desktop
      # rerun
    ];
  };
}
