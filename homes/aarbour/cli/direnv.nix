{ config, ... }:
let
  inherit (config.alchemy.programs) defaults;
  inherit (config.alchemy) system;
in {
  programs.direnv = {
    enable = (system.isWorkstation);
    silent = true;
    nix-direnv.enable = true;
    
    # store direnv in cache and not per project
    # <https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories>
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs

      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
        )}"
      }
    '';
  };
}
