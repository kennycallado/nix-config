{config, ...}: {
  age.secrets.copilot = {
    file = ../../../secrets/copilot.age;
    path = "${config.xdg.configHome}/github-copilot/hosts.yml";
  };
}
