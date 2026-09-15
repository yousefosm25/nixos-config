{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 1;
    };
  };
}
