{ lib, ...}:
let
  inherit (lib) mkOption types;
in {
  imports = [
  ] ++ (with builtins; map (fn: ./${fn}) (filter (fn: fn != "default.nix") (attrNames (readDir ./.))));
  
  options.alchemy.system.hardware.cpu = mkOption {
    type = types.nullOr (
      types.enum [
        "intel"
        "amd"
      ]
    );
    default = null;
    description = "Manufacturer of CPU...";
  };
}
