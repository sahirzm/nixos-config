{
	description = "Flake for my NixOS configuration";

	inputs = {
		nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
		home-manager = { 
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nur = {
			url = "github:nix-community/NUR";
		};

		emacs-overlay = {
			url = "github:nix-community/emacs-overlay";
			flake = false;
		};

		hyprland = {
			        url = "github:hyprwm/Hyprland";
		};

    ranger_devicons = {
      url = "github:alexanderjeurissen/ranger_devicons";
      flake = false;
    };

	};

	outputs = { self, nixpkgs, home-manager, nur, hyprland, emacs-overlay, ranger_devicons, ... }@inputs: 
		let
			user = "sahir";
		in {
			nixosConfigurations = (
				import ./hosts {
					inherit (nixpkgs) lib;
					inherit inputs user;
				}
			);
		};
}
