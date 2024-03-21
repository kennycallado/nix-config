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
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
  };

  outputs = inputs@{ home-manager, ... }:
    let
      config = rec {
        name = "vm"; # knowns: hplap | ryzen
        arch = "x86_64-linux";
        is_vm = true;
        is_known = builtins.pathExists ./hosts/${name}/config.nix; # check if host is known

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

        sshd = {
          enable = false;
          tunnel = {
            enable = false;
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
          name = "kennycallado";
          email = "kennycallado@hotmail.com";
          username = "kenny";
          password = "kenny"; # be aware; used for unknown hosts

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
      host =
        if (!config.is_known)
        then ({ config = config; })
        else (import ./hosts/${config.name}/config.nix { inherit inputs; });
      # -- evaluation --
    in
    {
      nixosConfigurations."${if (host.config.is_known) then host.config.name else "unknown" }" = inputs.nixpkgs.lib.nixosSystem {
        system = host.config.arch;
        specialArgs = {
          inherit host;
          inputs = inputs;
        };

        modules = [
          ./hosts
          ./modules/gaming
          ./modules/desktop
          ./modules/development
          ./modules/sshd
          ./modules/virtualization

          {
            gaming = host.config.gaming;
            desktops = host.config.desktops;
            development = host.config.development;
            virtualization = host.config.virtualization;
            sshd = host.config.sshd;
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
