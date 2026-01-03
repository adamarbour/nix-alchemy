{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs { inherit system; config = {}; overlays = []; },
}:
let
  lib = pkgs.lib.extend (final: prev: {
    alchemy = import ./lib/alchemy-lib.nix { lib = prev; };
  });
in {
  meta = {
    description = "To obtain... something of equal value must be lost.";
    nixpkgs = pkgs;
    specialArgs = { inherit sources lib; };
  };
  defaults = { lib, name, ... }: {
    imports = [
      ({...}: { _module.args.lib = lib; })  # Custom helpers
      ./modules/disks
      ./modules/nixos
      ./homes
    ];
    config = {
      networking.hostName = name;
      deployment.targetUser = lib.mkDefault null;
    };
  };
  
  ### SYSTEM DEFINITIONS
  feyre = {
    imports = [
      ./systems/feyre/configuration.nix
      ./systems/feyre/disk.nix
    ];
    config = {
      time.timeZone = "America/Chicago";
      deployment = {
        allowLocalDeployment = true;
        targetHost = "100.75.8.103";
      };
    };
  };
  nesta = {
    imports = [
      ./systems/nesta/configuration.nix
      ./systems/nesta/disk.nix
    ];
    config = {
      time.timeZone = "America/Chicago";
      deployment = {
        allowLocalDeployment = true;
        targetHost = null;
      };
    };
  };
}
