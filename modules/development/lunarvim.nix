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
      lunarvim
      # rust-analyzer # not sure if this is needed
      html-tidy # rest.nvim
    ];
  };
}
