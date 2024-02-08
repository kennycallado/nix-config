{ pkgs, inputs, host, lib, ... }:
let
  agenix = {
    imports = [ inputs.agenix.nixosModules.age ];
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.agenix ];
  };
in
{

  imports = [
    ./maintenance.nix
    agenix
  ];

  services.qemuGuest = lib.mkIf (host.config.is_vm) { enable = true; };

  # TODO move to flake?
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "google-chrome"
    "steam-original"
    "steam-run"
    "steam"
  ];

  # systemd.services.NetworkManager-wait-online.enable = false; # TODO where?
  networking.useNetworkd = true;
  networking.hostName = "${host.config.name}";
  networking.networkmanager.enable = true;
  # networking.firewall.allowedTCPPorts = [ 8888 ];

  users = {
    mutableUsers = false; # maybe true?
    users."${host.config.user.username}" = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
      hashedPassword = "${host.config.user.userHashedPassword}";
      openssh.authorizedKeys.keys = [ "${host.config.user.sshPublicKey}" ];
    };
    users.root.hashedPassword = "${host.config.user.rootHashedPassword}";
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
      neovim
      lm_sensors
    ] ++ host.config.extraPackages;
  };

  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
}
