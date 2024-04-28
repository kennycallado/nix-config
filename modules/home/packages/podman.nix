{ ... }:

{
  home.file.".config/containers" = {
    source = ../files/podman;
    recursive = true;
  };
}
