# zed.nix: Zed editor, covering the same languages as the LazyVim config
{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    # Extensions for languages Zed doesn't ship with.
    # Python, Rust, Go, C/C++, TS/TSX, CSS, Bash, JSON and Markdown are built in.
    # Check names in Zed's Extensions panel if one fails to install.
    extensions = [
      "nix"
      "toml"
      "dockerfile"
      "scss"
      "vue"
      "cmake"
      "sql"
      "hyprlang"
      "typst"
      "templ"
      "ron"
      "wgsl"
    ];

    # Tools put on Zed's PATH (the equivalent of extraPackages and
    # installDependencies / installRuntimeDependencies in your nvim config)
    extraPackages = with pkgs; [
      # Language servers
      nixd # Nix
      bash-language-server # Bash
      rust-analyzer # Rust
      gopls # Go
      clang-tools # C/C++ (provides clangd)
      pyright # Python types
      ruff # Python lint/format
      vtsls # TypeScript
      tailwindcss-language-server # Tailwind

      # Formatters
      alejandra # Nix
      gofumpt # Go

      # Runtimes the servers need
      cargo
      rustc
      go
      python3
    ];

    userSettings = {
      # Per-server config: the key is the server's name in Zed.
      # "binary.path" pins the exact Nix binary so Zed never downloads one.
      lsp = {
        rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";

        gopls = {
          binary.path = "${pkgs.gopls}/bin/gopls";
          initialization_options.gofumpt = true; # format with gofumpt
        };

        clangd.binary.path = "${pkgs.clang-tools}/bin/clangd";

        pyright.binary = {
          path = "${pkgs.pyright}/bin/pyright-langserver";
          arguments = [ "--stdio" ];
        };

        ruff.binary = {
          path = "${pkgs.ruff}/bin/ruff";
          arguments = [ "server" ]; # ruff runs as an LSP via "ruff server"
        };

        vtsls.binary = {
          path = "${pkgs.vtsls}/bin/vtsls";
          arguments = [ "--stdio" ];
        };

        tailwindcss-language-server.binary = {
          path = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
          arguments = [ "--stdio" ];
        };

        bash-language-server.binary = {
          path = "${pkgs.bash-language-server}/bin/bash-language-server";
          arguments = [ "start" ];
        };
      };

      # Per-language config
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ]; # use nixd, disable nil
          formatter.external = {
            command = "alejandra";
            arguments = [
              "--quiet"
              "-"
            ]; # "-" means read from stdin
          };
        };

        Python = {
          language_servers = [
            "pyright"
            "ruff"
          ];
          formatter.language_server.name = "ruff"; # format with ruff
        };
      };
    };
  };
}
