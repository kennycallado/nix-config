{
  description = "Kenny Callado's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.34.0";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs = inputs@{ home-manager, ... }:
    let
      host = {
        name = "ryzen"; # ryzen | hplap
        arch = "x86_64-linux";
        is_vm = true; # are we building for a VM?
        desktops = {
          enable = true;
          # terminal = inputs.nixpkgs.legacyPackages.x86_64-linux.alacritty; # default
          icewm.enable = true;
          icewm.default = true;
          hyprland.enable = true;
          sway.enable = false;
        };

        gaming.enable = false;

        virtualization = {
          enable = false;
          containers = {
            enable = false;
            backend = "docker"; # podman | docker
          };
        };

        user = {
          name = "Kenny Callado";
          email = "kennycallado@hotmail.com";
          username = "kenny";
          userHashedPassword = "$y$j9T$K.6mI6Iv5sfsaGlxYcSA61$TYINtbstV0sqY2DusfTGIaiTd.iKDmJ/QV.IE0Ubbf9"; # mkpasswd -m help
          rootHashedPassword = "$y$j9T$DH2RAr03g1LijzG.F6u9Y.$.3juBtQvbWBWpZTI6jpVcF04TXdXqOkbxhr/Ya.9bcA"; # mkpasswd -m help
        };

        extraPackages = with inputs.nixpkgs.legacyPackages."${host.arch}"; [
          firefox
        ];
      };
    in
    {
      nixosConfigurations."${host.name}" = inputs.nixpkgs.lib.nixosSystem {
        system = host.arch;
        specialArgs = {
          inherit host;
          inputs = inputs;
        };
        modules = [
          ./hosts
          ./modules/gaming
          ./modules/desktop
          ./modules/virtualization

          {
            gaming = host.gaming;
            desktops = host.desktops;
            virtualization = host.virtualization;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit host;
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${host.user.username}" = import ./modules/home;
          }
        ];
      };

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
