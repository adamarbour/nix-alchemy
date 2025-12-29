{ lib, name, config, sources, osConfig, ... }:
let
  inherit (lib) mkIf;
  secretsRepo = sources.secrets;
  cfg = osConfig.alchemy.secrets;
in {
  imports = [ (sources.sops-nix + "/modules/home-manager/sops.nix") ];
  
  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${secretsRepo}/secrets/users/${name}.yaml";
      age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      gnupg.sshKeyPaths = [ ];
    };
  };
}
