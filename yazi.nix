# /etc/nixos/yazi.nix — Home Manager module for Yazi
#
#   1. home.nix:  imports = [ ./yazi.nix ];
#   2. shell:     git add yazi.nix && sudo nixos-rebuild switch --flake .#nixos
#   3. launch:    `y`  (quit with q = your shell cd's to where you were; Q = stay put)
#
# Tested headless against Yazi 26.9.1 (current nixpkgs) using the exact plugin
# revisions nixpkgs pins. Needs a recent Home Manager (plugins.<name>.setup,
# extraPackages). Plugins and flavors are managed here, so don't use `ya pkg`.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Optional previewers. Each pulls in one small program; set to false to skip it.
  withMarkdownPreview = true; # glow  – rendered Markdown (README.md, docs)
  withTreePreview = true; # eza   – directory tree
  withHexPreview = true; # hexyl – hex dump for binaries (firmware, .bin, .elf, ...)

  # Catppuccin Mocha (dark) + Latte (light) from the official flavors repo.
  flavorsSrc = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "1183892c904f7f0efdf4473e856ed308b7bea98d";
    hash = "sha256-E1OUF1+mT0V3crVxkewG2Y7hRu8fO+0oRl6NlINmw+o=";
  };
in
{
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";

    # Added to Yazi's PATH only (not your whole system).
    extraPackages =
      [ pkgs.wl-clipboard ] # copy paths/files (cc, cd, cf, cn) on Wayland
      ++ lib.optional withMarkdownPreview pkgs.glow
      ++ lib.optional withTreePreview pkgs.eza
      ++ lib.optional withHexPreview pkgs.hexyl;

    # ── yazi.toml ──────────────────────────────────────────────────────────
    settings = {
      mgr = {
        ratio = [
          1
          3
          4
        ]; # parent : current : preview
        sort_by = "natural";
        sort_dir_first = true;
        show_hidden = true; # toggle at runtime with "."
        show_symlink = true;
        linemode = "size_and_mtime"; # defined in initLua below
        scrolloff = 6;
      };

      # Sharper image previews (run `yazi --clear-cache` once after changing).
      preview = {
        max_width = 1000;
        max_height = 1000;
      };

      # Edit with $EDITOR, falling back to Neovim instead of vi.
      opener.edit = [
        {
          run = "\${EDITOR:-nvim} %s";
          desc = "$EDITOR";
          for = "unix";
          block = true;
        }
      ];

      plugin = {
        # Git status signs in the file list (git plugin below).
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];

        # `piper` runs any shell command as a previewer: $1 = file, $w = width,
        # $t = terminal theme ("dark" / "light").
        prepend_previewers =
          lib.optional withMarkdownPreview {
            url = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s="$([ "$t" = "light" ] && echo light || echo dark)" "$1"'';
          }
          ++ lib.optional withTreePreview {
            url = "*/";
            run = ''piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          };

        # Fallback for files nothing else previews (binaries): hex dump instead of `file`.
        append_previewers = lib.optional withHexPreview {
          url = "*";
          run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
        };
      };
    };

    # ── keymap.toml (prepend = adds to the default keys, doesn't replace them) ─
    keymap.mgr.prepend_keymap = [
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter directory / open file";
      }
      {
        on = "T";
        run = "plugin toggle-pane max-preview";
        desc = "Maximize / restore preview";
      }
      {
        on = "F";
        run = "plugin smart-filter";
        desc = "Smart filter";
      }
      {
        on = "M";
        run = "plugin mount";
        desc = "Mount manager (USB drives, SD cards)";
      }
      {
        on = [
          "c"
          "m"
        ];
        run = "plugin chmod";
        desc = "chmod selected files";
      }

      # Quick jumps (g h / g c / g d / g t already exist by default)
      {
        on = [
          "g"
          "n"
        ];
        run = "cd /etc/nixos";
        desc = "Go to /etc/nixos";
      }
      {
        on = [
          "g"
          "m"
        ];
        run = "cd /run/media/${config.home.username}";
        desc = "Go to mounted drives";
      }
    ];

    # ── theme: flips automatically with your terminal's light/dark mode ────
    theme.flavor = {
      dark = "catppuccin-mocha";
      light = "catppuccin-latte";
    };

    flavors = {
      catppuccin-mocha = "${flavorsSrc}/catppuccin-mocha.yazi";
      catppuccin-latte = "${flavorsSrc}/catppuccin-latte.yazi";
    };

    # ── plugins, straight from nixpkgs ─────────────────────────────────────
    plugins = {
      inherit (pkgs.yaziPlugins)
        smart-enter
        smart-filter
        toggle-pane
        chmod
        mount
        piper
        ;

      # These two have a setup() call; Home Manager writes it into init.lua.
      full-border = {
        package = pkgs.yaziPlugins.full-border; # rounded by default
        setup = true;
      };
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
    };

    # ── init.lua (appended after the plugin setup() calls) ─────────────────
    initLua = ''
      -- Custom linemode used by settings.mgr.linemode: "2.1K 11/13 20:01"
      function Linemode:size_and_mtime()
        return string.format("%s %s", self:size(), self:mtime())
      end
    '';
  };
}
