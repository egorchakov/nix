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

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = ["mesa"];
  };

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
}
