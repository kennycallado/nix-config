{ pkgs, ... }:

{
  # home.packages = with pkgs; [ ];

  home.file.".config/Thunar" = {
    source = ../files/Thunar;
    recursive = true;
  };
}
