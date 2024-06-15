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

  networking.interfaces.enp42s0.wakeOnLan.enable = true;
  networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;

  console.keyMap = "es";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  system.stateVersion = "23.11";
}
