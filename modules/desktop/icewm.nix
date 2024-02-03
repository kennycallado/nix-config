{ config, lib, pkgs, ... }:

let
  cfg = config.desktops.icewm;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.desktops.icewm = {
    enable = mkEnableOption "Icewm window manager";
    default = mkEnableOption "Make Icewm the default session";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [ ];

    environment.systemPackages = with pkgs; [
      volumeicon
    ];

    services.xserver = {
      windowManager.icewm.enable = true;

      displayManager.defaultSession = mkIf cfg.default "icewm-session";

      displayManager.session = [{
        manage = "desktop";
        name = "icewm-session";
        start = ''
          exec icewm-session &
          waitPID=$!
        '';
      }];
    };
  };
}
