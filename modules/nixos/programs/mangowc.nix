{ lib, config, sources, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.alchemy) anyHome;
  inherit (config.alchemy) system;
  flakeCompat = (import sources.flake-compat { src = sources.mangowc; }).defaultNix;
  hasMango = anyHome config (conf: conf.wayland.windowManager.mango.enable);
in {
  imports = [ flakeCompat.nixosModules.mango ];
  
  config = mkIf ((system.isGraphical) && hasMango) {
    programs.mango.enable = true;
  };
}
