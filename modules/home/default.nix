{ inputs, pkgs, host, lib, config, ... }:

{
  imports = [
    ./packages
    inputs.agenix.homeManagerModules.age
  ];

  home.packages = with pkgs; [
    youtube-tui
    yt-dlp
    # lxappearance
    # pkgs.papirus-icon-theme
    (import ./scripts/wallsetter.nix { inherit pkgs config; })
    (import ./scripts/wez-ssh.nix { inherit pkgs; })
  ];

  home.username = "${host.user.username}";
  home.homeDirectory = "/home/${host.user.username}";
  home.stateVersion = "23.11";

  home.file."${config.xdg.userDirs.pictures}/wallpapers" = {
    source = ../home/media/wallpapers;
    recursive = true;
  };

  home.file.".config/lvim/config.lua" = {
    source = ./files/lunarvim/config.lua;
  };

  programs.git = {
    enable = true;
    userName = host.user.name; # options for home-manager ??
    userEmail = host.user.email; # options for home-manager ??
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   x11.enable = false;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  #   size = 24;
  # };

  # needs to be set in the user's home directory
  dconf.settings = lib.mkIf (host.virtualization.enable) {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };
    theme = {
      name = "Adementary-dark";
      package = pkgs.adementary-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
