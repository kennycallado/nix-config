{ ... }:

{
  # home.packages = with pkgs; [ ];

  home.file.".config/hypr" = {
    source = ../files/hypr;
    recursive = true;
  };
}
