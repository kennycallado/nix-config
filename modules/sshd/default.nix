{ lib, config, pkgs, ... }:
let
  cfg = config.sshd;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{

  options.sshd = {
    enable = mkEnableOption "Enable OpenSSH server.";
    tunnel = {
      enable = mkEnableOption "Enable bore tunnel for ssh server.";
      server = mkOption { type = lib.types.str; };
      pass = mkOption { type = lib.types.str; };
      port = mkOption { type = lib.types.int; };
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        # X11Forwarding = true;
        # setXAuthLocation = true;
        # KbdInteractiveAuthentication = false;
      };
    };

    systemd.services.tunnel-sshd = mkIf cfg.tunnel.enable {
      enable = true;
      description = "Bore tunnel for sshd";

      after = [ "network.target" "sshd.service" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = { Type = "Simple"; };

      serviceConfig = {
        ExecStart = "${pkgs.bore-cli}/bin/bore local 22 --port ${builtins.toString cfg.tunnel.port} --to ${cfg.tunnel.server} --secret ${cfg.tunnel.pass}";
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
        # StandardOutput = "file:/home/kenny/tunnel-sshd.log"; # temp
      };
    };
  };
}
