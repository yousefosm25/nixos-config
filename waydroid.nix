{ pkgs, ... }:
{
  virtualisation.waydroid.enable = true;
  # Newer kernel versions may need
  #wall runs on nftables rather than iptables by default
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  # optional: share the clipboard between host and the Android container
  environment.systemPackages = with pkgs; [
    wl-clipboard
    waydroid-helper
  ];
  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };
  services.geoclue2.enable = true;
}
