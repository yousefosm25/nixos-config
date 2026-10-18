{
  config,
  pkgs,
  lazyvim,
  ...
}:
{
  imports = [
    ./packages.nix
    ./terminal/zsh.nix
    ./terminal/nvim.nix
    ./arduino-fhs.nix
    ./python.nix
    ./obs.nix
    ./plasma.nix
    ./ghostty.nix
    ./tomat.nix
    ./zed.nix
    lazyvim.homeManagerModules.default
  ];
  programs.lazyvim.enable = true;
  home.username = "yousef";
  home.homeDirectory = "/home/yousef";
  home.stateVersion = "26.05";
}
