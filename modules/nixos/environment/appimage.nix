{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf genAttrs;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    environment.systemPackages = with pkgs; [
      appimage-run
    ];
    
    boot.binfmt.registrations = genAttrs [ "appimage" "AppImage" ]
      (ext: {
        recognitionType = "extension";
        magicOrExtension = ext;
        interpreter = "/run/current-system/sw/bin/appimage-run";
      });
  };
}
