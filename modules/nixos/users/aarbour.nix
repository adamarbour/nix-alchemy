{ lib, pkgs, config, ... }:
let
  inherit (lib) elem mkIf mkDefault mkMerge;
  users = config.alchemy.system.users;
  secrets = config.alchemy.secrets;
in {  
  config = mkIf (elem "aarbour" users) {
    users.users.aarbour = mkMerge [
    		{
		    openssh.authorizedKeys.keyFiles = [
          (builtins.fetchurl {
            url = "https://github.com/adamarbour.keys";
            sha256 = "1njavb03fnnqxd4zw19lfcggg04v9clkjz50gwg2inn2hvr6kr60";
          })
	      ];
	    }
    		(mkIf (!secrets.enable) {
    			# Initial throwaway password: "nixos"
      		initialHashedPassword = mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    		})
    ];
  };
}
