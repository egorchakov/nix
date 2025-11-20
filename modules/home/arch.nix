{ config, pkgs, ... }:
{
  imports = [
    ./shared.nix
    ./linux.nix
    ./gui.nix
  ];

  targets.genericLinux = {
    enable = true;
    gpu.enable = true;
  };

  home.packages = with pkgs; [
    bluetui
    pavucontrol
    signal-desktop
    google-chrome
    slack
    telegram-desktop
  ];

  stylix.targets = {
    gtk.enable = true;
    tofi.enable = true;
  };
}
