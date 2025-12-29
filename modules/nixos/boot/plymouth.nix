{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
  inherit (config.alchemy.boot) silentBoot;
in {
  config = mkIf (system.isGraphical && silentBoot) {
    boot.kernelParams = [
      "plymouth.use-simpledrm"
    ];
    boot.plymouth = {
      enable = true;
      theme = "circle_flow";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "circle_flow" ];
        })
      ];
    };
  };
}
