{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/" = { device = "/dev/disk/by-label/ROOT"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/BOOT"; };
  fileSystems."/nix/store" = { device = "/dev/disk/by-label/STORE"; };
  fileSystems."/home" = { device = "/dev/disk/by-label/HOME"; };
  fileSystems."/home/shared" = {
    device = "/dev/disk/by-label/SHARED";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "user" "exec" "umask=000" "locale=es_ES.utf8" ];
  };
  swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.

  networking.useDHCP = lib.mkDefault false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
