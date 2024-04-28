{ pkgs, inputs, host, lib, config, ... }:

let
  agenix = {
    imports = [ inputs.agenix.nixosModules.age ];
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.agenix ];
  };

  inherit (lib) mkIf getName;
in
{

  imports = [
    agenix
    ./extra/maintenance.nix
  ];

  services.qemuGuest = mkIf (host.config.is_vm) { enable = true; };
  services.blueman.enable = config.hardware.bluetooth.enable;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
    "vscode"
    "google-chrome"
    "steam-original"
    "steam-run"
    "steam"
  ];

  networking.useNetworkd = true;
  networking.hostName = "${host.config.name}";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 8000 ];

  users = {
    mutableUsers = false; # maybe true?
    users."${host.config.user.username}" = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
      password = mkIf (!host.config.is_known) "${host.config.user.password}";
      hashedPassword = mkIf (host.config.is_known) "${host.config.user.userHashedPassword}";
      openssh.authorizedKeys.keys = mkIf (host.config.is_known) [ "${host.config.user.sshPublicKey}" ];
    };
    users.root.hashedPassword = mkIf (host.config.is_known) "${host.config.user.rootHashedPassword}";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.git.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      wget
      tree
      file
      htop
      killall
      jq
      p7zip
      unzip
      unar
      lm_sensors
      cryptsetup
    ];
    # ] ++ host.config.extraPackages; # already in home default
  };

  environment.variables = {
    PAGER = "less";
  };
}
