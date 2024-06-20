{ pkgs, config, lib, host, ... }:
let
  graphics = {
    services.xserver = {
      enable = true;
      xkb.layout = "es";
      xkb.variant = "";

      # libinput = {
      #   enable = true;
      #   #touchpad.tapping = true;
      # };

      # displayManager.lightdm.enable = false;
      displayManager.gdm = {
        enable = true;
        wayland = true;
        autoSuspend = host.config.desktops.xrdp.enable;
      };

      # displayManager.startx = {
      #   enable = true;
      # };
    };
  };

  guiFileManager = {
    environment.systemPackages = with pkgs; [
      pcmanfm
      xarchiver
    ];

    services.gvfs.enable = true; # Mount usb drives
  };

  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption;
in
{
  imports = [
    ./sway.nix
    ./icewm.nix
    ./wayland.nix
    ./hyprland.nix
    ./xrdp.nix
    graphics
    guiFileManager
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
  };

  config = mkIf cfg.enable {

    # security-------------------------------------------------------------------
    # security.rtkit.enable = true;
    # security.polkit.enable = true;

    # services-------------------------------------------------------------------
    # systemd = {
    #   user.services.polkit-gnome-authentication-agent-1 = {
    #     description = "polkit-gnome-authentication-agent-1";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #       Restart = "on-failure";
    #       RestartSec = 1;
    #       TimeoutStopSec = 10;
    #     };
    #   };
    # };

    # hardware ----------------------------------------------------------------
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };

    # fonts----------------------------------------------------------------------
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      ocr-a
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # packages-------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      # basic packages for all desktops
      pavucontrol
      pulseaudio # audio
      networkmanagerapplet # network manager applet
      xorg.xf86inputlibinput # ??
      libinput # ??
      # polkit # ??
      # polkit_gnome # ??
      imv # image viewer
      # mpv
      zathura # pdf viewer
      alacritty
      leafpad # text editor
      luakit # web browser
      rofi-wayland # app launcher
      rofi-power-menu
      yad # better zenity
    ];

    environment.variables = {
      WEBKIT_DISABLE_COMPOSITING_MODE=1;
    };
  };
}
