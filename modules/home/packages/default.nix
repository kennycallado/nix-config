{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./copilot.nix
    ./docker.nix
    ./gh.nix
    ./hyprland.nix
    ./icewm.nix
    ./joshuto.nix
    ./pcmanfm.nix
    ./rofi.nix
    ./swaync.nix
    ./thunar.nix
    ./waybar.nix
    ./wezterm.nix
  ];

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    # ?? should be in global.nix ??
    bottom # btm
    fzf
    bat
    ripgrep
    fd
    dufs # droopy replacement
    dua
    lsd
    cmatrix
  ];
}
