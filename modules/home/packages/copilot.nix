{config, ...}: {
  age.secrets.gh = {
    file = ../../../secrets/copilot.age;
    path = "${config.xdg.configHome}/github-copilot/hosts.yml";
  };
}
