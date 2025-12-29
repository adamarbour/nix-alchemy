{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isWorkstation) {
    home.packages = with pkgs; [
      (microsoft-edge.override {
        commandLineArgs = [
          # Force GPU accleration
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
          # Force to run on Wayland
          "--ozone-platform-hint=auto"
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
          # Reduce memory usage
          "--process-per-site"
          # Enable additional features
          "--enable-features=WebUIDarkMode,UseOzonePlatform,VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,WebRTCPipeWireCapturer,WaylandWindowDecorations"
        ];
      })
    ];
  };
}
