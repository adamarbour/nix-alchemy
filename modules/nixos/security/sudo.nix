{ lib, pkgs, config, ... }:
let
  inherit (lib) mkDefault getExe';
in {
  config = {
    security.sudo-rs = {
      enable = true;
      wheelNeedsPassword = mkDefault false;
      execWheelOnly = true;
      extraConfig = ''
        Defaults !lecture
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH DISPLAY"
        Defaults timestamp_timeout = 300
      '';
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            # try to make nixos-rebuild work without password
            {
              command = getExe' config.system.build.nixos-rebuild "nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
            # allow reboot and shutdown without password
            {
              command = getExe' pkgs.systemd "systemctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = getExe' pkgs.systemd "reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = getExe' pkgs.systemd "shutdown";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
