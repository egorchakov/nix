{ pkgs, ... }:
{
  programs.ghostty = {
    package = pkgs.ghostty-bin;
  };

  stylix.fonts.sizes.terminal = 14;
}
