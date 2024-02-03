{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.desktops.hyprland;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.hyprland = {
    enable = mkEnableOption "Hyprland window manager";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      swaylock
      swayidle
      wdisplays
      libnotify # icewm use its own
      swww
      grim
      slurp
      libnotify
      wl-clipboard
    ];

    # todo esto es para hyprland ??
    security.pam.services.swaylock = { };

    # creo que no es necesario ...
    # xdg.portal.config.common.default = "*";
    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = false;
    #   gtkUsePortal = true;
    #   extraPortals = with pkgs; [
    #     #xdg-desktop-portal-hyprland
    #     #xdg-desktop-portal-gtk
    #     #xdg-desktop-portal-wlr
    #   ];
    #   wlr.enable = true;
    # };


    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };

      waybar.enable = true;

      # waybar = {
      #   enable = true;
      #   package = pkgs.waybar;
      # };
    };
  };
}
