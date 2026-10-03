{ _ }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.yousef.extraGroups = [ "libvirtd" ];
}
