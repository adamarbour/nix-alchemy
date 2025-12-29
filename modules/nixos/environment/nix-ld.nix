{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  
  programs.nix-ld = mkIf (system.isGraphical) {
    enable = true;
    libraries = builtins.attrValues {
      inherit (pkgs)
        openssl
        curl
        glib
        util-linux
        glibc
        icu
        libunwind
        libuuid
        zlib
        libsecret
        freetype
        libglvnd
        libnotify
        sdl3
        vulkan-loader
        gdk-pixbuf
        ;
      inherit (pkgs.stdenv.cc) cc;
      inherit (pkgs.xorg) libX11;
    };
  };
}
