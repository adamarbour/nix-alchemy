{ lib, config, osConfig, ... }:
{
  config = {
    programs.ssh = {
      enable = osConfig.services.openssh.enable;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          forwardAgent = false;
          compression = true;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          userKnownHostsFile = "~/.ssh/known_hosts";
          hashKnownHosts = true;
        };
      };
    };

    services.ssh-agent.enable = osConfig.services.openssh.enable;
  };
}
