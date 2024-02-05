{config, ...}: {
  age.secrets.docker = {
    file = ../../../secrets/docker.age;
    path = "$HOME/.docker/config.json"; # TODO: test $HOME
  };
}
