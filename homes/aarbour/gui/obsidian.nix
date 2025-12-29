{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    programs.obsidian = {
      enable = true;
      package = pkgs.unstable.obsidian;
      vaults = {
        Hierocles = {
          enable = true;
          target = "Documents/Notes/Journal";
        };
        Voltaire = {
          enable = true;
          target = "Documents/Notes/Brain";
        };
      };
      defaultSettings = {
        app = {
          vimMode = true;
          spellcheck = true;
          attachmentFolderPath = "./attachments";
        };
      };
    };
  };
}
