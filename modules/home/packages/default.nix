{ inputs, pkgs, is_nixos, ... }:

{
  imports = [
    ./gh.nix
    ./bash.nix
    ./rofi.nix
    ./icewm.nix
    ./docker.nix
    ./swaync.nix
    ./thunar.nix
    ./waybar.nix
    ./copilot.nix
    ./joshuto.nix
    ./pcmanfm.nix
    ./hyprland.nix
    ./alacritty.nix
    (import ./wezterm.nix { inherit inputs pkgs is_nixos; })
  ] ++ (if (!is_nixos) then [./podman.nix] else []);

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
