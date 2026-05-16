{
  config,
  pkgs,
  lumen,
  ...
}:
{
  home.packages = with pkgs; [
    tig
    just
    dust
    ouch
    rsync
    lumen.packages.${system}.lumen
  ];

  programs = {
    bat.enable = true;
    ripgrep.enable = true;
    skim.enable = true;
    zoxide.enable = true;
    uv.enable = true;
    bottom.enable = true;
    htop.enable = true;
    gh.enable = true;
    nix-your-shell.enable = true;
    carapace.enable = true;
    nh.enable = true;
    television.enable = true;
    fd.enable = true;

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    atuin = {
      enable = true;
      settings = {
        auto_sync = false;
        update_check = false;
        search_mode = "skim";
        search_mode_shell_up_key_binding = "skim";
        inline_height = 10;
        keymap_mode = "vim-insert";
      };
    };

    starship = {
      enable = true;
      settings.format = "$username$hostname$directory$git_branch$git_state$nix_shell$direnv$python\n$character";
    };

    nushell = {
      enable = true;
      shellAliases = {
        cx = "codex";
        zl = "zellij";
        gi = "gst-inspect-1.0";
        gl = "gst-launch-1.0";
      };
      environmentVariables = config.home.sessionVariables;
      settings = {
        show_banner = false;
      };
      # plugins = with pkgs.nushellPlugins; [
      # skim
      # polars
      # highlight
      # ];
      extraConfig = ''
        const NU_LIB_DIRS = $NU_LIB_DIRS ++ ['${pkgs.nu_scripts}/share/nu_scripts']

        use custom-completions/aerospace/aerospace-completions.nu *
        use custom-completions/docker/docker-completions.nu *
        use custom-completions/nix/nix-completions.nu *
        use custom-completions/git/git-completions.nu *
        use custom-completions/just/just-completions.nu *
        use custom-completions/pre-commit/pre-commit-completions.nu *
        use custom-completions/rg/rg-completions.nu *
        use custom-completions/ssh/ssh-completions.nu *
        use custom-completions/uv/uv-completions.nu *
        use custom-completions/zellij/zellij-completions.nu *
      '';
    };

    zellij = {
      enable = true;
      settings = {
        default_shell = "nu";
        simplified_ui = true;
        show_startup_tips = false;
        keybinds = {
          unbind = [
            "Ctrl h"
            "Ctrl n"
            "Ctrl o"
          ];

          "shared_except \"locked\" \"resize\"" = {
            bind = {
              _args = [ "Ctrl z" ];
              _children = [ { SwitchToMode._args = [ "resize" ]; } ];
            };
          };

          "shared_except \"locked\" \"move\"" = {
            bind = {
              _args = [ "Ctrl e" ];
              _children = [ { SwitchToMode._args = [ "move" ]; } ];
            };
          };

          "shared_except \"locked\" \"session\"" = {
            bind = {
              _args = [ "Ctrl s" ];
              _children = [ { SwitchToMode._args = [ "session" ]; } ];
            };
          };
        };
      };
    };
  };
}
