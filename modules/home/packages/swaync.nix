{ ... }:

{
  home.file.".config/swaync/config.json" = {
    source = ../files/swaync/config.json;
  };

  home.file.".config/swaync/style.css" = {
    source = ../files/swaync/style.css;
  };
}
