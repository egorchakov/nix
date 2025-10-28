{
  config,
  pkgs,
  nixgl,
  ...
}:
{
  imports = [
    ./shared.nix
    ./linux.nix
    ./gui.nix
  ];

  home.packages = with pkgs; [
    bluetui
    pavucontrol
    signal-desktop
    (config.lib.nixGL.wrap google-chrome)
    (config.lib.nixGL.wrap slack)
    (config.lib.nixGL.wrap telegram-desktop)
  ];

  nixGL = {
    inherit (nixgl) packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
}
