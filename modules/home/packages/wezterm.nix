{ inputs, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    package = inputs.unstable.legacyPackages.${pkgs.system}.wezterm;
    # package = pkgs.wezterm; # from repo

    # extraConfig = '' '';
  };

  # installed via unstable
  # nix-env -f channel:nixpkgs-unstable -iA wezterm

  home.file.".config/wezterm" = {
    source = ../files/wezterm;
    recursive = true;
  };

  # NOTE: maybe is ready on 24.05 ??
  # programs.wezterm = {
  #   -- local wezterm = require("wezterm") -- NOTE: done by the package
  #   enable = true;
  #   extraConfiga = ''
  #     local config = {}

  #     -- QUICK FIX
  #     config.enable_wayland = false

  #     return config
  #   '';
  # };
}
