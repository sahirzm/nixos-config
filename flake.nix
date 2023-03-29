{
	description = "Flake for my NixOS configuration";

	inputs = {
		nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
		home-manager = { 
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs: 
		let
		system = "x86_64-linux";
	user = "sahir";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};
	lib = nixpkgs.lib;
		in {
			nixosConfigurations = {
				laptop = lib.nixosSystem {
					inherit system;
					specialArgs = inputs;
					modules = [ ./configuration.nix ];
				};
			};
		};
}
