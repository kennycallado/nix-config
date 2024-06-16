{ pkgs, is_nixos, ... }:

{
  imports = [
    ./gh.nix
    ./bash.nix
    ./rofi.nix
    ./icewm.nix
    ./docker.nix
    ./swaync.nix
    ./thunar.nix
    ./zoxide.nix
    ./waybar.nix
    ./copilot.nix
    ./joshuto.nix
    ./pcmanfm.nix
    ./wezterm.nix
    ./hyprland.nix
    ./lunarvim.nix
    ./readline.nix
    ./alacritty.nix
  ] ++ (if (!is_nixos) then [ ./podman.nix ] else [ ]);

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
