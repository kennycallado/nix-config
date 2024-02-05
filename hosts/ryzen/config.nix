{ inputs, ... }:

{
  config = {
    is_known = true;

    name = "ryzen"; # ryzen | hplap
    arch = "x86_64-linux";
    is_vm = true; # are we building for a VM?
    desktops = {
      enable = true;
      # terminal = inputs.nixpkgs.legacyPackages.x86_64-linux.alacritty; # default
      icewm.enable = true;
      icewm.default = false;
      hyprland.enable = true;
      sway.enable = false;
    };

    gaming.enable = false;

    virtualization = {
      enable = false;
      containers = {
        enable = false;
        backend = "podman"; # podman | docker
      };
    };

    user = {
      name = "Kenny Callado";
      email = "kennycallado@hotmail.com";
      username = "kenny";
      userHashedPassword = "$y$j9T$K.6mI6Iv5sfsaGlxYcSA61$TYINtbstV0sqY2DusfTGIaiTd.iKDmJ/QV.IE0Ubbf9"; # mkpasswd -m help
      rootHashedPassword = "$y$j9T$DH2RAr03g1LijzG.F6u9Y.$.3juBtQvbWBWpZTI6jpVcF04TXdXqOkbxhr/Ya.9bcA"; # mkpasswd -m help
      pref = {
        browser = "firefox";
        terminal = "alacritty";
      };
    };

    development = {
      enable = false;
      lunarvim.enable = false;
      rust.enable = false;
    };

    extraPackages = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
      firefox
    ];
  };
}
