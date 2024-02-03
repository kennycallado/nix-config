{ pkgs, ... }:

{
  home.packages = with pkgs; [ wezterm ];

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
