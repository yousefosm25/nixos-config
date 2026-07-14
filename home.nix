{ config, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  home.username = "yousef";
  home.homeDirectory = "/home/yousef";
  home.stateVersion = "26.05";
}
