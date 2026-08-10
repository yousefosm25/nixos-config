{
  config,
  pkgs,
  lazyvim,
  ...
}:
{
  imports = [

    ./terminal/zsh.nix
    ./terminal/nvim.nix
    ./waydroid.nix
    lazyvim.homeManagerModules.default
  ];
  programs.lazyvim.enable = true;

  home.username = "yousef";
  home.homeDirectory = "/home/yousef";
  home.stateVersion = "26.05";
}
