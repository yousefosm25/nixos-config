{ pkgs, ... }:

{
  virtualisation.waydroid.enable = true;

  # swap in the nftables-compatible build — needed because
  # NixOS's firewall runs on nftables rather than iptables by default
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  # optional: share the clipboard between host and the Android container
  environment.systemPackages = [ pkgs.wl-clipboard ];
}
