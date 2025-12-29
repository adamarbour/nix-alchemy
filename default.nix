{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs { inherit system; config = {}; overlays = []; },
}:
let
  colmena = pkgs.callPackage "${sources.colmena}/package.nix" {};
in rec {
  shell = pkgs.mkShellNoCC {
    NIX_PATH = "nixpkgs=${pkgs.path}";
    packages = with pkgs; [
      age
      colmena
      disko
      dix
      git
      just
      nix-output-monitor
      nixos-install
      nixos-generators
      nixos-rebuild
      npins
      pciutils
      sbctl
      ssh-to-age
      usbutils
    ];
  };
}
