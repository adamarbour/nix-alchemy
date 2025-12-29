{ lib, ... }:
let
  inherit (lib) types mkOption mapAttrs;
  mkDefaults = name: args: mkOption ({ description = "default ${name} for the system"; } // args);
in {
  options.alchemy.programs.defaults = mapAttrs mkDefaults {
    shell = {
      type = types.enum [ "bash" "zsh" "fish" "nushell" "ion" ];
      default = "bash";
    };
    pager = {
      type = types.str;
      default = "less -FR";
    };
  };
}
