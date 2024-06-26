{ lib, config, pkgs, ... }:
let

  cfg = config.development.lunarvim;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.development.lunarvim = {
    enable = mkEnableOption "LunarVim distro";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jq
      fd
      ripgrep
      # lunarvim # TODO: temp broken
      html-tidy # rest.nvim
    ];
  };
}
