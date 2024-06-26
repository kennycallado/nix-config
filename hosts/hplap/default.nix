{ lib, ... }:

let
  sound = {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix
    ../../system/global.nix
    sound
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp2s0.wakeOnLan.enable = true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true; # nm-applet will manage this

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # prefer not poweronboot, but i'll try

  console.keyMap = "es";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  system.stateVersion = "23.11";
}
