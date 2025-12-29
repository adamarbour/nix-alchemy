{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  environment.defaultPackages = mkForce [ ];
}
