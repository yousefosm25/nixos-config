# hyprland.nix - Hyprland (Wayland tiling compositor) as a NixOS module
#
# Import it next to your other modules, e.g. in configuration.nix:
#   imports = [ ./hyprland.nix ];
#
# programs.hyprland already turns on the portals, polkit, dconf and XWayland,
# and registers the session with your display manager, so none of that is
# repeated here. This uses Hyprland from nixpkgs (no extra flake input and no
# Cachix), so it comes from the normal binary cache.
{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended session manager; adds "Hyprland (uwsm-managed)" to SDDM
    xwayland.enable = true; # lets X11 apps run (already the default, kept explicit)
  };

  # Make Electron/Chromium apps (VS Code, Discord, browsers...) use Wayland natively
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Only the tools Hyprland's default config calls, to keep the download small
  environment.systemPackages = with pkgs; [
    kitty # SUPER+Q  terminal
    hyprlauncher # SUPER+R  app launcher
    brightnessctl # brightness keys
    playerctl # media keys
    wl-clipboard # wl-copy / wl-paste
    grim # screenshots
    slurp # pick a screen region for grim
    waypaper
    waybar
    hyprpaper
  ];

  # brightnessctl needs the "video" group to change brightness without sudo
  users.users.yousef.extraGroups = [ "video" ];

  # NVIDIA: nothing added on purpose. On a hybrid AMD + NVIDIA laptop with PRIME
  # offload, Hyprland should run on the AMD iGPU. Do NOT copy the usual
  # GBM_BACKEND / __GLX_VENDOR_LIBRARY_NAME / LIBVA_DRIVER_NAME env vars from
  # desktop-NVIDIA guides, they would push the whole session onto the dGPU.
}
