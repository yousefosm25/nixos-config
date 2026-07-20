{ config, pkgs, ... }:
{
  imports = [
    ./terminal/zsh.nix
    ./terminal/neovim.nix
    ./browsers-config/browser.nix
  ];

  home.username = "yousef";
  home.homeDirectory = "/home/yousef";
  home.stateVersion = "26.05";
}
