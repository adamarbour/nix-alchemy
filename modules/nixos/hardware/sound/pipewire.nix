{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    environment.systemPackages = [ pkgs.alsa-utils pkgs.pavucontrol ];
    
    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      extraConfig.pipewire = {
        "10-loopback" = {
          "context.modules" = [
            {
              "node.description" = "playback loop";
              "audio.position" = [
                "FL"
                "FR"
              ];
              "capture.props" = {
                "node.name" = "playback_sink";
                "node.description" = "playback-sink";
                "media.class" = "Audio/Sink";
              };
              "playback.props" = {
                "node.name" = "playback_sink.output";
                "node.description" = "playback-sink-output";
                "media.class" = "Audio/Source";
                "node.passive" = true;
              };
            }
          ];
        };
        "92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 44100;
            "default.clock.quantum" = 512;
            "default.clock.min-quantum" = 512;
            "default.clock.max-quantum" = 512;
          };
        };
      };
    };
    
    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
    
    services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';
    
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "524288";
      }
    ];
  };
}

