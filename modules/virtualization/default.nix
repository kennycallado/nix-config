{ config, lib, pkgs, host, ... }:
let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.virtualization = {
    enable = mkEnableOption "Virtualization";
    containers = {
      enable = mkEnableOption "Containers";
      backend = mkOption {
        type = lib.types.enum [ "docker" "podman" ];
        default = "podman";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users."${host.user.username}" = {
      extraGroups = [ "libvirtd" ] ++ lib.lists.optional
        (cfg.containers.enable && (cfg.containers.backend == "docker")) "docker";
    };

    programs.virt-manager.enable = true;

    # Should be in home-manager
    # dconf.settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = [ "qemu:///system" ];
    #     uris = [ "qemu:///system" ];
    #   };
    # };

    virtualisation = {
      podman = mkIf (cfg.containers.enable && (cfg.containers.backend == "podman")) {
        # TESTING
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        extraPackages = [ pkgs.podman-compose ];
      };

      docker = mkIf (cfg.containers.enable && (cfg.containers.backend == "docker")) {
        # TESTING
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };

      libvirtd = {
        enable = true;
        # TESTING
        # qemu = {
        #   swtpm.enable = true;
        #   ovmf.enable = true;
        #   ovmf.packages = [ pkgs.OVMFFull.fd ];
        # };
      };

      spiceUSBRedirection.enable = true;
    };
  };
}
