{ pkgs, user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    packages = with pkgs; [
      whatsapp-for-mac
      google-chrome
      chatgpt
      bitwarden-desktop
      slack
      # telegram-desktop
      # rerun
    ];
  };
}
