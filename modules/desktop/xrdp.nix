{ lib, config, pkgs, ... }:
let
  cfg = config.desktops.xrdp;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{

  options.desktops.xrdp = {
    enable = mkEnableOption "Enable Xrdp server.";
    tunnel = {
      enable = mkEnableOption "Enable bore tunnel for xrdp.";
      server = mkOption { type = lib.types.str; };
      pass = mkOption { type = lib.types.str; };
      port = mkOption { type = lib.types.int; };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      #icewm # should be selected before...
      # bore-cli
    ];

    # networking.firewall.allowedTCPPorts = [ 3389 ];

    services.xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
      openFirewall = true;
    };

    systemd.services.tunnel-xrdp = mkIf cfg.tunnel.enable {
      enable = true;
      description = "Bore tunnel for xrdp";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = { Type = "Simple"; };

      serviceConfig = {
        ExecStart = "${pkgs.bore-cli}/bin/bore local 3389 --port ${builtins.toString cfg.tunnel.port} --to ${cfg.tunnel.server} --secret ${cfg.tunnel.pass}";
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
        # StandardOutput = "file:/home/kenny/tunnel-xrdp.log"; # temp
      };
    };
  };
}
