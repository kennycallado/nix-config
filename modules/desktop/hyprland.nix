{ lib, config, pkgs, ... }:

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
      swaynotificationcenter
      libnotify # icewm use its own
      wdisplays
      wlogout # logout dialog # TODO: implement it
      wl-clipboard
      swww
      grim
      slurp
    ];

    # todo esto es para hyprland ??
    security.pam.services.swaylock = { };

    xdg.portal.config.common.default = "*";
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-hyprland
        # xdg-desktop-portal-gtk
        # xdg-desktop-portal-wlr
      ];
      wlr.enable = true;
    };


    programs = {
      hyprland = {
        enable = true;
      };

      # waybar.enable = true;
    };
  };
}
