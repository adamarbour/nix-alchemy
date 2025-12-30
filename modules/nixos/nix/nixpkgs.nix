{ lib, sources, ... }:
let
  inherit (lib) mkDefault;
in {
  nixpkgs = {
    hostPlatform = mkDefault "x86_64-linux";
    overlays = [
      (import ../../../overlays/unstable.nix)
      (import ../../../overlays/nix-cachyos-kernel.nix)
      (import ../../../overlays/mangowc.nix)
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowVariants = true;
      allowBroken = false;
      permittedInsecurePackages = [ ];
      allowUnsupportedSystem = false;
      allowAliases = false;
    };
  };
}
