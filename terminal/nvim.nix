{ lazyvim, pkgs, ... }:
{
  programs.lazyvim = {
    enable = true;

    extras = {
      util.dot.enable = true; # bash + hyprland.conf + waybar/kitty/rofi/mako filetypes
      lang.tailwind.enable = true;
      lang.typescript.vtsls.enable = true; # traditional/stable TS backend — LazyVim
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # Install ruff
        installRuntimeDependencies = true; # Install python3
      };
      lang.rust = {
        enable = true;
        installDependencies = true; # rust-analyzer, codelldb, bacon
        installRuntimeDependencies = true; # cargo, rustc
      };
      lang.clangd = {
        enable = true;
        installDependencies = true; # clangd, codelldb
      };
      lang.go = {
        enable = true;
        installDependencies = true; # Install gopls, gofumpt, etc.
        installRuntimeDependencies = true; # Install go compiler
      };
    };

    # Additional packages (optional)
    extraPackages = with pkgs; [
      nixd # Nix LSP
      alejandra # Nix formatter
      bash-language-server
    ];
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      wgsl
      templ
      angular
      clojure
      cmake
      cpp
      css
      dockerfile
      gitattributes
      gitcommit
      git_config
      gitignore
      git_rebase
      go
      gomod
      gosum
      gowork
      ninja
      ron
      rst
      ruby
      rust
      scss
      sql
      typst
      vue
      hyprlang
    ];
  };
}
