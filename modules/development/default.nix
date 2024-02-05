{ pkgs, config, lib, ... }:
let
  cfg = config.development;
  inherit (lib) mkIf mkEnableOption;
in
{
  imports = [
    ./lunarvim.nix
    ./rust.nix
  ];

  options.development = {
    enable = mkEnableOption "Development";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
    ];
  };
}
