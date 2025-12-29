{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault mkMerge;
  mainUser = config.alchemy.system.mainUser;
  secrets = config.alchemy.secrets;
in {  
  config = {
    users.users.root = mkMerge [
    		{ shell = pkgs.bashInteractive; }
    		(mkIf (secrets.enable) {
    			hashedPasswordFile = config.users.users.${mainUser}.hashedPasswordFile;
    		})
    		(mkIf (!secrets.enable) {
    			# Initial throwaway password: "nixos"
      		initialHashedPassword = mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    		})
    ];
  };
}
