{ agenix, pkgs, lib, config, host, ... }:

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

home.activation = {
  copyFont = let
      font_src = "${pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }}/share/fonts/truetype/NerdFonts/Fira Code Regular Nerd Font Complete Mono.ttf";
      font_dst = "${config.home.homeDirectory}/.termux/font.ttf";
    in lib.hm.dag.entryAfter ["writeBoundary"] ''
      ( test ! -e "${font_dst}" || test $(sha1sum "${font_src}"|cut -d' ' -f1 ) != $(sha1sum "${font_dst}" |cut -d' ' -f1)) && $DRY_RUN_CMD install $VERBOSE_ARG -D "${font_src}" "${font_dst}"
  '';
};
}
