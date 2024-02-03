{ config, ... }:

{
  # There is no config option for launch terminal here
  # `roxterm -d %u`

  home.file.".config/pcmanfm/default" = {
    source = config.lib.file.mkOutOfStoreSymlink ../files/pcmanfm;
    recursive = true;
  };
}
