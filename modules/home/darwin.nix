{lib, ...}: {
  imports = [./shared.nix];
  programs = {
    aerospace = {
      enable = true;
      launchd.enable = true;
      userSettings = {
        exec.env-vars = {
          PATH = lib.concatStringsSep ":" [
            "/etc/profiles/per-user/evgenii/bin" # FIXME
            "/run/current-system/sw/bin"
            "/usr/local/bin"
            "/usr/bin"
            "/bin"
            "/usr/sbin"
            "/sbin"
          ];
        };
        mode.main.binding = {
          alt-enter = "exec-and-forget open -n -b com.mitchellh.ghostty";
          alt-o = "exec-and-forget open -n -b com.google.Chrome";
          alt-q = "close --quit-if-last-window";
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-h = "focus --boundaries all-monitors-outer-frame --boundaries-action stop left";
          alt-j = "focus --boundaries all-monitors-outer-frame --boundaries-action stop down";
          alt-k = "focus --boundaries all-monitors-outer-frame --boundaries-action stop up";
          alt-l = "focus --boundaries all-monitors-outer-frame --boundaries-action stop right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-shift-minus = "resize smart -50";
          alt-shift-equal = "resize smart +50";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 10";
          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          alt-shift-semicolon = "mode service";
        };
        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          f = ["layout floating tiling" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];
          alt-shift-h = ["join-with left" "mode main"];
          alt-shift-j = ["join-with down" "mode main"];
          alt-shift-k = ["join-with up" "mode main"];
          alt-shift-l = ["join-with right" "mode main"];
        };
        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "main";
          "3" = "main";
          "4" = "main";
          "5" = "main";
          "6" = "main";
          "7" = "secondary";
          "8" = "secondary";
          "9" = "secondary";
          "10" = "secondary";
        };
      };
    };
  };
  xdg.configFile = {
    "ghostty/config" = {
      enable = true;
      text = ''
        shell-integration = none
        command = nu

        window-inherit-working-directory = true
        window-decoration = false
        macos-titlebar-style = hidden

        font-size = 20
        font-family = Iosevka Fixed
        theme = UltraDark

        focus-follows-mouse = true
      '';
    };
  };
}
