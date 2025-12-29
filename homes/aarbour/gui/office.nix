{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isWorkstation) {
    home.packages = with pkgs; [
      # Office
      libreoffice-fresh
      onlyoffice-desktopeditors
      hunspell
      hunspellDicts.en_US
      hyphen
      hyphenDicts.en_US
      # PDF
      kdePackages.okular
    ];
  };
}
