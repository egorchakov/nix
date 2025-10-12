{
  config,
  inputs,
  pkgs,
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
  ];

  nixGL = {
    inherit (inputs.nixgl) packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
}
