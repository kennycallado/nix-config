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
      openssl
      gcc
      cargo
      cargo-cross
      rustc
      rustup # ???
      pkg-config
      rust-analyzer
    ];
  };
}
