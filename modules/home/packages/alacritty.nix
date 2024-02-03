{ ... }: {
  home.file.".config/alacritty" = {
    source = ../files/alacritty;
    recursive = true;
  };
}
