{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "virt-manager-mesa";
      paths = [ pkgs.virt-manager ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/virt-manager \
          --unset GBM_BACKEND \
          --unset __NV_PRIME_RENDER_OFFLOAD \
          --set __GLX_VENDOR_LIBRARY_NAME mesa \
          --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
      '';
    };
  };
  users.users.yousef.extraGroups = [ "libvirtd" ];
}
