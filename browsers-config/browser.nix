{ pkgs, lib, zen-browser, ... }:
let
 #wrapFirefoxBrowser = import ./firefox-config.nix { inherit pkgs lib; };
  unwrapped = zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped;
in
{
  home.packages = [
    #(wrapFirefoxBrowser unwrapped)
  ];
}
