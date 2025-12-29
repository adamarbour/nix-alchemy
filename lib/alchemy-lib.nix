{ lib, ... }:
let
  inherit (lib) any elem filter hasAttr getAttrFromPath;
in rec {

  # VALIDATOR - USER
  groupExist = config: groups: filter (group: hasAttr group config.users.groups) groups;
  anyHome = conf: cond: let
  		list = map (user: getAttrFromPath [ "home-manager" "users" user ] conf) conf.alchemy.system.users;
  		in any cond list;
  
  # VALIDATOR - PROFILES
  hasProfile = profile: profiles: elem profile profiles;
}
