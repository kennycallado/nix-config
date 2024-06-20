{ lib, agenix, pkgs, host, is_nixos, ... }:
let
  # michaelCtsHm = builtins.fetchTarball "https://github.com/michaelCTS/home-manager/archive/refs/heads/feat/add-nixgl-workaround.zip";
  # nixGlModule = "${michaelCtsHm}/modules/misc/nixgl.nix";

  inherit (lib) mkIf;
in
{
  imports = [
    ./media
    ./packages
    # nixGlModule
    agenix.homeManagerModules.age
  ];

  home.stateVersion = "23.11";

  home.username = "${host.config.user.username}";
  home.homeDirectory = "/home/${host.config.user.username}";

  # workarounds.nixgl = mkIf (!is_nixos) {
  #   packages = with pkgs; [
  #     # { pkg = wezterm; }
  #     { pkg = inputs.unstable.legacyPackages.${pkgs.system}.wezterm; }
  #   ];
  # };

  home.packages = with pkgs; [
    gh # in case not installed
    mpv
    yt-dlp
    (import ./scripts/lvim.nix { inherit pkgs; })
    (import ./scripts/rvim.nix { inherit pkgs; })
    (import ./scripts/zvim.nix { inherit pkgs; })
  ]
  ++ host.config.extraPackages
  ++ [
    # inputs.unstable.legacyPackages.${pkgs.system}.yt-dlp
    # inputs.unstable.legacyPackages.${pkgs.system}.mpv
  ]
  ++ (
    if is_nixos then [
      (import ./scripts/wallsetter.nix { inherit pkgs config; })
      (import ./scripts/wez-ssh.nix { inherit pkgs; })
    ] else with pkgs; [
      nixgl.nixGLIntel
    ]
  );

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = host.config.user.name; # options for home-manager ??
    userEmail = host.config.user.email; # options for home-manager ??
  };

  home.file.".ssh/authorized_keys" = mkIf (!is_nixos) {
    text = host.config.user.sshPublicKey;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = false;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # services.remmina = {
  #   enable = true;
  #   systemdServices.enable = false;
  # };

  # needs to be set in the user's home directory
  dconf.settings = mkIf (host.config.virtualization.enable && is_nixos) {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  qt = mkIf (is_nixos) {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = mkIf (is_nixos) {
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

  # A bit pain to set up, for now I'll just use the default
  # environment.variables = {
  #   DOCKER_CONFIG = "${config.home.homeDirectory}/.config/containers/docker";
  #   DOCKER_CERT_PATH = "${config.home.homeDirectory}/.config/containers/certs";
  #   REGISTRY_AUTH_FILE = "${config.home.homeDirectory}/.config/containers/auth.json";
  # };
}
