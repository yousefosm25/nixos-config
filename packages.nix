{ pkgs, zen-browser, ... }:
{
  home.packages = with pkgs; [
    wget
    git
    ghostty
    direnv
    nixfmt
    tree
    fzf
    fastfetch
    gcc
    gnumake
    nodejs
    starship
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pyright
    proton-vpn
    openvpn
    mangohud
    heroic
    vlc
    zoom-us
    telegram-desktop
    spotify
    btop
    vscode-langservers-extracted
    typescript-language-server
    vtsls
    tailwindcss-language-server
    biome
    vue-language-server
    angular-language-server
    onlyoffice-desktopeditors
    golangci-lint
    lmstudio
    prettier
    kdePackages.kclock
    kdePackages.kate
    statix
    gotools
    evcxr
    baobab
    android-tools
    exercism
    #arduino-cli
    #arduino-ide
    #godot
    code-cursor
    tomat
    kdePackages.plasma-browser-integration
    xournalpp
    unrar
    shfmt
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
