{ pkgs, ... }:
{
  home.packages = [ pkgs.kdePackages.kwin-effects-forceblur ];

  programs.plasma = {
    enable = true;
    configFile."kwinrc" = {
      # built-in blur (transparent windows, panels, menus)
      Plugins.blurEnabled = true;
      "Effect-blur" = {
        BlurStrength = 10; # 1-15
        NoiseStrength = 3; # 0-14
      };

      # Better Blur: force blur on all windows
      Plugins.forceblurEnabled = true;
      "Effect-forceblur" = {
        BlurStrength = 10;
        NoiseStrength = 3;
        WindowClasses = ""; # empty list of classes...
        BlurMatching = false; # ...treated as blacklist = blur everything
        TopCornerRadius = 12; # optional rounded corners
        BottomCornerRadius = 12;
      };
    };
  };
}
