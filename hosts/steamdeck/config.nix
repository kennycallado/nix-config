{ inputs, ... }:

{
  config = rec {
    name = "steamdeck";
    arch = "x86_64-linux";
    is_vm = false; # are we building for a VM?
    is_known = true;

    # desktops = {
    #   enable = true;
    #   sway.enable = false;
    #   icewm.enable = true;
    #   icewm.default = false; # set icewm session as default
    #   hyprland.enable = true;

    #   xrdp = {
    #     enable = false;
    #     tunnel = {
    #       enable = false;
    #       server = "";
    #       port = 19;
    #       pass = "";
    #     };
    #   };
    # };

    # sshd = {
    #   enable = false;
    #   tunnel = {
    #     enable = false;
    #     server = "";
    #     pass = "";
    #     port = 12;
    #   };
    # };

    # gaming.enable = true;

    virtualization = {
      enable = false;
      containers = {
        enable = false;
        backend = "podman";
      };
    };

    user = {
      name = "kennycallado";
      email = "kennycallado@hotmail.com";
      username = "deck";
      sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg4qvvrvP7BSMLUqPNz2+syXHF1+7qGutKBA9ndPBB+ kennycallado@hotmail.com";
      userHashedPassword = "$y$j9T$K.6mI6Iv5sfsaGlxYcSA61$TYINtbstV0sqY2DusfTGIaiTd.iKDmJ/QV.IE0Ubbf9"; # mkpasswd -m help
      rootHashedPassword = "$y$j9T$DH2RAr03g1LijzG.F6u9Y.$.3juBtQvbWBWpZTI6jpVcF04TXdXqOkbxhr/Ya.9bcA"; # mkpasswd -m help

      pref = {
        browser = "firefox";
        terminal = "wezterm";
      };
    };

    development = {
      enable = false;
      lunarvim.enable = false;
      rust.enable = false;
    };

    extraPackages = with inputs.nixpkgs.legacyPackages.${arch}; [
      xclip
      podman
      podman-compose
      neovim
      lunarvim
      firefox
    ];
  };
}
