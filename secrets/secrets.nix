{ host }:
let
  keys = [ "${host.config.user.userHashedPassword}" ];
in
{
  "copilot.age".publicKeys = keys;
  "docker.age".publicKeys = keys;
  "gh.age".publicKeys = keys;
}
