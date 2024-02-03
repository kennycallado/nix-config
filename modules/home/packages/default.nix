{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./hyprland.nix
    ./icewm.nix
    ./joshuto.nix
    ./pcmanfm.nix
    ./rofi.nix
    ./thunar.nix
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
