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
    ./rofi.nix
    ./icewm.nix
    ./swaync.nix
    ./thunar.nix
    ./waybar.nix
    ./pcmanfm.nix
    ./hyprland.nix
  ] else [
    ./podman.nix
  ]);

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    # ?? should be in global.nix ??
    fd
    fzf
    bat
    dua
    lsd
    dufs # droopy replacement
    # bottom # btm
    ripgrep
    cmatrix
  ];
}
