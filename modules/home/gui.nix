{ pkgs, ... }:
{
  programs = {
    ghostty = {
      enable = true;
      settings = {
        command = "${pkgs.bashInteractive}/bin/bash -l -c nu";
        window-inherit-working-directory = true;
        window-decoration = false;
        focus-follows-mouse = true;
        shell-integration-features = "sudo,ssh-env,ssh-terminfo";
      };
    };
  };

  stylix.targets.ghostty.enable = true;
}
