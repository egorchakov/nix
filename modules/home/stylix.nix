{ pkgs, stylix, ... }:
{
  imports = [ stylix.homeModules.stylix ];
  disabledModules = [
    "${stylix}/modules/blender/hm.nix"
    "${stylix}/modules/kde/hm.nix"
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/evenok-dark.yaml";
    fonts = {
      monospace = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
    };
  };
}
