{ lib, ...}:
let
  inherit (lib) mkOption types;
in {
  imports = [
  ] ++ (with builtins; map (fn: ./${fn}) (filter (fn: fn != "default.nix") (attrNames (readDir ./.))));
  
  options.alchemy.system.hardware.gpu = mkOption {
    type = types.nullOr (
      types.enum [
        "intel"
        "amd"
        "nvidia"
      ]
    );
    default = null;
    description = "Manufacturer of GPU...";
  };
}
