{
  home.shellAliases = {
    mkdir = "mkdir -pv"; # always create parent dirs
    df = "df -h"; # human readable
    jctl = "journalctl -p 3 -xb"; # get error messages from current boot
  };
}
