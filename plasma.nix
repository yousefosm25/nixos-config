{ pkgs, better-blur-dx, ... }:
{
  # home.packages = [
  #   better-blur-dx.packages.${pkgs.stdenv.hostPlatform.system}.default # Wayland
  # ];
  #
  # programs.plasma = {
  #   enable = true;
  # window-rules = [
  #   {
  #       description = "translucency for blur on all windows";
  #       match = {
  #         window-class = {
  #           value = ".*";
  #           type = "regex";
  #         };
  #         window-types = [ "normal" ];
  #       };
  #       apply = {
  #         opacityactive = {
  #           value = 95;
  #           apply = "force";
  #         };
  #         opacityinactive = {
  #           value = 80;
  #           apply = "force";
  #         };
  #       };
  #     }
  #     {
  #       description = "zen already has its own transparency";
  #       match = {
  #         window-class = {
  #           value = "zen";
  #           type = "substring";
  #         };
  #       };
  #       apply = {
  #         opacityactive = {
  #           value = 100;
  #           apply = "force";
  #         };
  #         opacityinactive = {
  #           value = 100;
  #           apply = "force";
  #         };
  #       };
  # }
  # ];
  # #
  # configFile."kwinrc" = {
  #   # stock blur must stay off - it conflicts with Better Blur DX
  #   Plugins.blurEnabled = false;
  #   Plugins.better_blur_dxEnabled = true;
  #   "Effect-better-blur-dx" = {
  #     BlurStrength = 15; # 1-15
  #     NoiseStrength = 3;
  #     # empty class list + "blur non-matching" = blur every window
  #     WindowClasses = "";
  #     BlurMatching = false;
  #     BlurNonMatching = true;
  #     BlurDecorations = true;
  #     CornerRadius = 12.0; # rounded corners (single value now, not top/bottom)
  #     BlurMenus = true; # optional: also blur menus
  #     BlurDocks = true; # optional: also blur panels
  #   };
  # };
  # };
}
