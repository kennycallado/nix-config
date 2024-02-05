{ pkgs, inputs, host, lib, ... }:
let

  agenix = {
    imports = [ inputs.agenix.nixosModules.age ];
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.agenix ];
  };

in
{
  imports = [
    agenix
  ];

  services.qemuGuest = lib.mkIf (host.config.is_vm) {
    enable = true;
  };

  # nixpkgs.config.allowUnfree = true; # TODO move to flake cfg?
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "google-chrome"
    "steam"
    "steam-original"
    "steam-run"
  ];

  systemd.services.NetworkManager-wait-online.enable = false; # TODO where?

  networking.useNetworkd = true;
  networking.hostName = "${host.config.name}";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 8888 ];

  environment = {
    systemPackages = with pkgs; [
      # host.extraPackages
      curl
      wget
      tree
      file
      htop
      # bottom # TODO move to home-manager
      killall
      jq
      p7zip
      unzip
      unar
      neovim
      lm_sensors # it's ok here?
    ] ++ host.config.extraPackages;

    variables = {
      EDITOR = "nvim";
      PAGER = "less";
    };
  };

  programs.git.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.UseDns = true;
  };

  users = {
    mutableUsers = false;
    users."${host.config.user.username}" = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
      hashedPassword = "${host.config.user.userHashedPassword}";
    };
    users.root.hashedPassword = "${host.config.user.rootHashedPassword}";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      # TESTING
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-older-than 7d";
      # };
    };
  };
}
