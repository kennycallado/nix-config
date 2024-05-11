{ inputs, pkgs, lib, agenix, host, is_nixos, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    openssh
    neovim
    curl
    git

    # Some common stuff that people expect to have
    procps
    killall
    #diffutils
    #findutils
    #utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    unar
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "23.11";

  # "JetBrainsMono"
  terminal.font  = ''${pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }}/share/fonts/truetype/NerdFonts/Fira Code Regular Nerd Font Complete Mono.ttf'';

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Madrid";

  # Configure home-manager
  home-manager = {
    extraSpecialArgs = let is_nixos = false; in { inherit inputs agenix host is_nixos; };
    config = ../modules/home/droid.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };
}
