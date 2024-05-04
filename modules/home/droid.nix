{ agenix, pkgs, lib, host, ... }:

{
  imports = [
    ./packages/droid.nix
    agenix.homeManagerModules.age
  ];

  home.stateVersion = "23.11";

  age.identityPaths = [
    "/data/data/com.termux.nix/files/home/.ssh/id_ed25519"
  ];

  home.packages = with pkgs; [
    agenix.packages.${pkgs.system}.agenix
    gcc # neovim
  ];

  programs.git = {
    enable = true;
    userName = host.config.user.name;
    userEmail = host.config.user.email;
  };

  home.file.".ssh/authorized_keys" = {
    text = host.config.user.sshPublicKey;
  };
}
