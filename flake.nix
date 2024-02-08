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
      known = ""; # ryzen | hplap

      config = {
        name = "vm";
        arch = "x86_64-linux";
        is_vm = true; # are we building for a VM?
        # hardwarePath = "/etc/nixos/hardware-configuration.nix"; # nixos-generate-config --show-hardware-config

        desktops = {
          enable = true;

          sway.enable = false;
          icewm.enable = true;
          icewm.default = false; # set icewm session as default
          hyprland.enable = false;

          xrdp = {
            enable = false;
            tunnel = {
              enable = false;
              server = "";
              pass = "";
              port = 19;
            };
          };
        };

        system.sshd = {
          enable = true;
          tunnel = {
            enable = true;
            server = "";
            pass = "";
            port = 12;
          };
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
          sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg4qvvrvP7BSMLUqPNz2+syXHF1+7qGutKBA9ndPBB+ kennycallado@hotmail.com";
          userHashedPassword = "$y$j9T$K.6mI6Iv5sfsaGlxYcSA61$TYINtbstV0sqY2DusfTGIaiTd.iKDmJ/QV.IE0Ubbf9"; # mkpasswd -m help
          rootHashedPassword = "$y$j9T$DH2RAr03g1LijzG.F6u9Y.$.3juBtQvbWBWpZTI6jpVcF04TXdXqOkbxhr/Ya.9bcA"; # mkpasswd -m help

          pref = {
            browser = "luakit";
            terminal = "alacritty";
          };
        };

        development = {
          enable = false;
          lunarvim.enable = false;
          rust.enable = false;
        };

        extraPackages = with inputs.nixpkgs.legacyPackages."${host.arch}"; [
          # firefox
        ];
      };

      # -- evaluation --
      is_known = builtins.pathExists ./hosts/${known}/config.nix;
      host =
        if (is_known)
        then (import ./hosts/${known}/config.nix { inherit inputs; })
        else { config = config; };
      # -- evaluation --
    in
    {
      # nixosConfigurations."${host.config.name}" = inputs.nixpkgs.lib.nixosSystem {
      nixosConfigurations."${if (is_known) then host.config.name else "unknown" }" = inputs.nixpkgs.lib.nixosSystem {
        system = host.config.arch;
        specialArgs = {
          inherit host;
          inherit is_known;
          inputs = inputs;
        };

        modules = [
          ./hosts
          ./modules/gaming
          ./modules/desktop
          ./modules/development
          ./modules/virtualization
          ./system/sshd.nix

          {
            gaming = host.config.gaming;
            desktops = host.config.desktops;
            development = host.config.development;
            virtualization = host.config.virtualization;
            system.sshd = host.config.system.sshd;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit host;
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${host.config.user.username}" = import ./modules/home;
          }
        ];
      };

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
