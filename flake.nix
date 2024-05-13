{
  description = "Kenny Callado's NixOS configuration";

  # raspi5
  nixConfig = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
  };

  inputs = {
  # raspi5
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    # nixpkgs.url = "github:NixOS/nixpkgs/8bf65f17d8070a0a490daf5f1c784b87ee73982c";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.34.0";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs = inputs@{ raspberry-pi-nix , nixgl, agenix, nix-on-droid, home-manager, nixpkgs, ... }:
    let
      config = rec {
        name = "vm"; # knowns: hplap | ryzen | steamdeck
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

      # -- for home-manager switch
      pkgs = nixpkgs.legacyPackages.${config.arch};
    in
    {
      nixosConfigurations."${if (host.config.is_known) then host.config.name else "unknown" }" = inputs.nixpkgs.lib.nixosSystem {
        system = host.config.arch;
        specialArgs = { inherit host inputs raspberry-pi-nix; };

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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = let is_nixos = true; in { inherit inputs agenix host is_nixos; };
            home-manager.users."${host.config.user.username}" = import ./modules/home;
          }
        ];

        # ++ nixpkgs.lib.mkIf host.config.name == "raspi5lab" [
        #     raspberry-pi-nix.nixosModules.raspberry-pi
        #     {
        #       raspberry-pi-nix.uboot.enable = false;
        #     }
        # ];
      };

      homeConfigurations."${if (host.config.is_known) then host.config.name else "unknown" }" = home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = let is_nixos = false; in { inherit inputs agenix host is_nixos; };
        pkgs = import nixpkgs {
          system = "${host.config.arch}";
          overlays = [ nixgl.overlay ];
        };

        modules = [
          ./modules/home
          # { programs.home-manager.enable = true; }
        ];
      };

      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = let is_nixos = false; in { inherit inputs agenix host is_nixos; };
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          overlays = [
            nix-on-droid.overlays.default
          ];
        };

        home-manager-path = home-manager.outPath;

        modules = [
          ./system/droid.nix
        ];
      };

      formatter.${host.config.arch} = inputs.nixpkgs.legacyPackages.${host.config.arch}.nixpkgs-fmt;
    };
}
