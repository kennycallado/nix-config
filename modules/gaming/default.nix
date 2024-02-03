{ config, pkgs, lib, ... }:
let
  cfg = config.gaming;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.gaming = {
    enable = mkEnableOption "Gaming";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    boot.kernelModules = [ "xpad" ]; # xpad driver for xbox controller
    boot.extraModulePackages = [
      (config.boot.kernelPackages.callPackage ./xpad.nix { })
    ];

    services.udev.extraRules = ''
      ACTION=="add", \
      ATTRS{idVendor}=="2dc8", \
      ATTRS{idProduct}=="3106", \
      RUN+="${pkgs.kmod}/bin/modprobe xpad", \
      RUN+="${pkgs.bash}/bin/sh -c 'echo 2dc8 3106 > /sys/bus/usb/drivers/xpad/new_id'"
    '';
  };
}
