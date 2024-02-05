{config, ...}: {
  age.secrets.docker = {
    file = ../../../secrets/docker.age;
    path = "${config.home.homeDirectory}.docker/config.json";
  };
}
