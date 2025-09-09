{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    tig
    just
    ytt
    dust
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.shell = {
    enableNushellIntegration = true;
  };

  programs = {
    nh.enable = true;
    home-manager.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
    skim.enable = true;
    zoxide.enable = true;
    uv.enable = true;

    git = {
      enable = true;
      userEmail = "evgorchakov@gmail.com";
      userName = "Evgenii Gorchakov";
      delta.enable = true;
      lfs.enable = true;
    };

    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableNushellIntegration = true;
      plugins = with pkgs.yaziPlugins; {
        full-border = full-border;
        chmod = chmod;
        starship = starship;
        git = git;
      };
      initLua = ''
        require("full-border"):setup {
          type = ui.Border.PLAIN,
        }
        require("starship"):setup()
        require("git"):setup()
      '';
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
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
      settings = {
        format = "$all$nix_shell";
      };
      enableNushellIntegration = true;
    };

    nushell = {
      enable = true;
      shellAliases = {
        zl = "zellij";
        f = "yazi";
      };
      environmentVariables = config.home.sessionVariables;
      settings = {
        show_banner = false;
      };
    };

    zellij = {
      enable = true;
      settings = {
        theme = "dracula";
        default_shell = "nu";
        simplified_ui = true;
        default_layout = "compact";
        show_startup_tips = false;
        keybinds = {
          unbind = ["Ctrl h" "Ctrl n"];

          "shared_except \"locked\" \"resize\"" = {
            bind = {
              _args = ["Ctrl z"];
              _children = [
                {SwitchToMode._args = ["resize"];}
              ];
            };
          };
          "shared_except \"locked\" \"move\"" = {
            bind = {
              _args = ["Ctrl e"];
              _children = [
                {SwitchToMode._args = ["move"];}
              ];
            };
          };
        };
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      themes = {
        tokyonight_black = {
          inherits = "tokyonight";
          "ui.background" = {fg = "fg";};
          "ui.text" = {fg = "fg";};
        };
      };

      settings = {
        theme = "tokyonight_black";
        editor = {
          auto-save = true;
          true-color = true;
          idle-timeout = 0;
          completion-trigger-len = 1;

          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [];
            right = ["diagnostics" "version-control"];
          };

          indent-guides = {
            render = true;
            skip-levels = 2;
          };

          soft-wrap = {
            enable = true;
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          file-picker = {
            hidden = false;
          };
        };
        keys = {
          insert = {
            esc = ["collapse_selection" "normal_mode"];
          };

          normal = {
            ";" = "command_mode";
            d = ["yank_joined_to_clipboard" "yank" "delete_selection"];
            y = ["yank_joined_to_clipboard" "yank"];
            C-h = "jump_view_left";
            C-j = "jump_view_down";
            C-k = "jump_view_up";
            C-l = "jump_view_right";
            esc = ["collapse_selection" "keep_primary_selection"];
          };

          select = {
            j = ["extend_line_down" "extend_to_line_bounds"];
            k = ["extend_line_up" "extend_to_line_bounds"];
          };
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {command = "alejandra";};
          }
          {
            name = "python";
            auto-format = true;
            language-servers = ["basedpyright" "ruff" "ty"];
          }
          {
            name = "toml";
            auto-format = true;
          }
        ];

        language-server = {
          basedpyright = with pkgs; {
            command = "${basedpyright}/bin/basedpyright-langserver";
            config = {
              lint = true;
              inlayHint.enable = true;
            };
          };
        };
      };
      extraPackages = with pkgs; [
        ruff
        ty
        tombi
        alejandra
        yaml-language-server
        nixd
        nil
      ];
    };
  };

  xdg.configFile = {
    "tig/config" = {
      enable = true;
      text = ''
        bind main R !git rebase -i %(commit)^
        bind diff R !git rebase -i %(commit)^
      '';
    };
  };
}
