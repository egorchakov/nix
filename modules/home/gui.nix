_: {
  programs = {
    ghostty = {
      enable = true;
      settings = {
        command = "bash -l -c nu";
        window-inherit-working-directory = true;
        window-decoration = false;
        focus-follows-mouse = true;
        shell-integration-features = "sudo,ssh-env,ssh-terminfo";
      };
    };
  };

  stylix.targets.ghostty.enable = true;
}
