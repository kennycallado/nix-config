{ inputs, pkgs, is_nixos, ... }:

{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./copilot.nix
    ./docker.nix
    ./gh.nix
    ./joshuto.nix
    (import ./wezterm.nix { inherit inputs pkgs is_nixos; })
  ]
  ++ (if is_nixos then [
      ./hyprland.nix
      ./icewm.nix
      ./pcmanfm.nix
      ./rofi.nix
      ./swaync.nix
      ./thunar.nix
      ./waybar.nix
    ] else []);

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    # ?? should be in global.nix ??
    # bottom # btm
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
