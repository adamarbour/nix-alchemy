{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.alchemy.secrets;
  secretsRepo = sources.secrets;
in {
  imports = [ (sources.sops-nix + "/modules/sops") ];
  
  options.alchemy.secrets = {
    enable = mkEnableOption "Enable secrets ... shhhh";
  };
  
  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${secretsRepo}/secrets/default.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      gnupg.sshKeyPaths = [ ];
    };
    
    environment.systemPackages = with pkgs; [
      	age
      	sops
      	ssh-to-age
    ];
  };
}
