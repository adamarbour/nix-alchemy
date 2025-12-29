{ config, ... }:
let
  inherit (config.alchemy.programs) defaults;
in {
  programs.bash.enable = defaults.shell == "bash";
  programs.zsh.enable = defaults.shell == "zsh";
  programs.fish.enable = defaults.shell == "fish";
  programs.ion.enable = defaults.shell == "ion";
  programs.nushell.enable = defaults.shell == "nushell";
  
  home.shell = {
    # disable the gloabl enable
    enableShellIntegration = false;

    enableBashIntegration = config.programs.bash.enable;
    enableIonIntegration = config.programs.ion.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
  };
}
