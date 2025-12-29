{ lib, pkgs, config, ...}:
let
  inherit (lib) optionals;
  inherit (config.alchemy) system;
in {
  fonts = {
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };
    fontDir.decompressFonts = true;
    packages = with pkgs; [
    ] ++ optionals (system.isGraphical) [
      corefonts
      vista-fonts
      
      ibm-plex
      
      source-sans
      source-serif
      
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      
      # icon fonts
      material-icons
      material-design-icons
      font-awesome
      
      # nerdfonts
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.jetbrains-mono
    ];
  };
}
