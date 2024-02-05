{inputs, ...}:

{
  config = {
    is_known = true;

    name = "hplap";
    arch = "x86_64-linux";
    is_vm = false;
    desktops = {
      enable = true;
      sway.enable = false;
      icewm.enable = true;
      icewm.default = false; # set icewm session as default
      hyprland.enable = true;
    };

    gaming.enable = true;

    virtualization = {
      enable = true;
      containers = {
        enable = true;
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
        terminal = "wezterm";
      };
    };

    development = {
      enable = true;
      lunarvim.enable = true;
      rust.enable = true;
    };

    extraPackages = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
      firefox
    ];
  };
}
