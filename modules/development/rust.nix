{ lib, config, pkgs, ... }:
let
  cfg = config.development.rust;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.development.rust = {
    enable = mkEnableOption "Rust development environment";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      cargo
      rustc
      pkg-config
      rust-analyzer
    ];
  };
}
