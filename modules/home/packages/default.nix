{ pkgs, is_nixos, ... }:

{
  imports = [
    ./gh.nix
    ./fzf.nix
    ./bash.nix
    ./rofi.nix
    ./icewm.nix
    ./docker.nix
    ./swaync.nix
    ./thunar.nix
    ./zoxide.nix
    ./waybar.nix
    ./zellij.nix
    ./copilot.nix
    ./joshuto.nix
    ./pcmanfm.nix
    ./wezterm.nix
    ./hyprland.nix
    ./lunarvim.nix
    # ./readline.nix
    ./alacritty.nix
  ] ++ (if (!is_nixos) then [ ./podman.nix ] else [ ]);

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    # ?? should be in global.nix ??
    fd
    bat
    dua
    lsd
    dufs # droopy replacement
    # bottom # btm
    ripgrep
    cmatrix
  ];
}
