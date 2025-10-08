{
  pkgs,
  config,
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
  ];

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
}
