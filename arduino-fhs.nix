# FHS-wrapped classic Arduino IDE, for ESP32 work.
# Only needed as a fallback if plain `arduino-ide` fails when Board
# Manager's downloaded ESP32 toolchain hits "cannot execute binary file"
# or missing .so errors — i.e. a genuine FHS incompatibility, not the
# dialout permissions issue.
#
# Usage: run `arduino-fhs` from a terminal, then `arduino` inside that shell.

{ pkgs, ... }:

let
  arduino-fhs = pkgs.buildFHSEnv {
    name = "arduino-fhs";
    targetPkgs = pkgs: with pkgs; [
      arduino
      ncurses
      zlib
      (python3.withPackages (ps: [ ps.pyserial ]))
    ];
    multiPkgs = null;
  };
in
{
  home.packages = [ arduino-fhs ];
}
