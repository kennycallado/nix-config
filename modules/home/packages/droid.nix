{ pkgs, ... }:

{
  imports = [
    ./gh.nix
    ./bash.nix
    # ./rofi.nix
    # ./icewm.nix
    # ./docker.nix
    # ./podman.nix
    # ./swaync.nix
    # ./thunar.nix
    # ./waybar.nix
    ./copilot.nix
    ./joshuto.nix
    # ./pcmanfm.nix
    # ./wezterm.nix
    # ./hyprland.nix
    ./lunarvim.nix
    # ./alacritty.nix
  ];

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    # ?? should be in global.nix ??
    gh
    fd
    fzf
    bat
    dua
    lsd
    dufs # droopy replacement
    htop
    which
    yt-dlp
    ripgrep
    cmatrix
  ];
}
