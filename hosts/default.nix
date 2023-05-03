{lib, inputs, user, ...}:

let
  system = "x86_64-linux";
  home-manager = inputs.home-manager;
  nixpkgs = inputs.nixpkgs;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  laptop = let
    host = {
      hostName = "nixos-laptop";
    };
  in lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system host user;
    };
    modules = [
      inputs.nur.nixosModules.nur
      inputs.hyprland.nixosModules.default
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user host builtins inputs;
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./laptop/home.nix
          ];
        };
      }
      {
        nixpkgs.overlays = [
          (import inputs.emacs-overlay)
          inputs.hyprland.overlays.default
        ];
      }
    ];
  };
}
