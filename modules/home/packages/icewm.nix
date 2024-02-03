{ pkgs, ... }:

{
  home.packages = with pkgs; [
    picom
  ];

  home.file.".icewm" = {
    source = ../files/icewm;
    recursive = true;
  };

  # don't seems to work
  # home.file.".icewm/icons" = {
  #   source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
  # };
}
