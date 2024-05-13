{ lib, ... }:

let
  sound = {
    sound.enable = false;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = false;
      alsa.enable = false;
      pulse.enable = false;
      alsa.support32Bit = false;
      jack.enable = false;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix
    ../../system/global.nix
    sound
  ];

  # boot.loader.systemd-boot.enable = false;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.wlan0.wakeOnLan.enable = true;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true; # nm-applet will manage this

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # prefer not poweronboot, but i'll try
  hardware.raspberry-pi.config.all = {
    base-dt-params = {
      # enable autoprobing of bluetooth driver
      # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
      krnbt = {
        enable = true;
        value = "on";
      };
    };
  };

  console.keyMap = "es";
  console.font = "Lat2-Terminus16";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  system.stateVersion = "23.11";
}
