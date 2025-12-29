{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) types optional mkIf mkOption genAttrs mkDefault;
  inherit (lib.alchemy) groupExist;
  inherit (config.alchemy) system secrets;
  secretsRepo = sources.secrets;
  userList = config.alchemy.system.users;
in {
  options.alchemy.system = {
    mainUser = mkOption {
      type = types.enum system.users;
      default = builtins.elemAt system.users 0;
      description = "The primary user of the system.";
    };
    users = mkOption {
      type = types.listOf types.str;
      default = [ "aarbour" ];
      description = ''
        A list of non-system users that should be declared for the host. The first user in the list will
        be treated as the Main User unless {option}`cauldron.system.mainUser` is set.
      '';
    };
  };

  config = {
    ####### SOPS secret declarations (one set per user) ########
    sops.secrets = mkIf secrets.enable
      (lib.foldl'
        (acc: name:
          let
            sopsFile = "${secretsRepo}/secrets/users/${name}.yaml";
          in acc // {
            # Per-user secrets with unique names
            "users/${name}/passwd" = {
              inherit sopsFile;
              key = "passwd";
              neededForUsers = true;
            };

            "users/${name}/id_ed25519" = {
              inherit sopsFile;
              key = "id_ed25519";
              owner = name;
              group = "users";
              mode  = "0600";
              # materialize where the user expects it
              path  = "/home/${name}/.ssh/id_ed25519";
            };

            "users/${name}/id_ed25519.pub" = {
              inherit sopsFile;
              key = "id_ed25519_pub";
              owner = name;
              group = "users";
              mode  = "0644";
              path  = "/home/${name}/.ssh/id_ed25519.pub";
            };
          })
        {}
      system.users);
    
    ####### Per-user accounts ########
    users.users = genAttrs system.users (name: {
      createHome = true;
      home = "/home/${name}";
      uid = mkDefault 1000;
      isNormalUser = mkDefault true;

      extraGroups = [ "wheel" "nix" ]
      ++ groupExist config [
        "network"
        "networkmanager"
        "systemd-journal"
        "audio"
        "pipewire" 
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "git"
        "libvirtd"
        "kvm"
        "incus"
        "incus-admin"
      ];

      hashedPasswordFile = mkIf secrets.enable
        config.sops.secrets."users/${name}/passwd".path;
      openssh.authorizedKeys.keyFiles = mkIf secrets.enable [
        config.sops.secrets."users/${name}/id_ed25519.pub".path
      ];
    });
  
    # User list check...
    warnings = optional (system.users == []) ''
      You have not added any users to be supported by your system.
      
      Consider setting {option}`config.alchemy.system.users` in your configuration.
    '';
  };
}
