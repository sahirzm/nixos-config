{lib, inputs, nixpkgs, user, home-manager, nur, ...}:

let
system = "x86_64-linux";

pkgs = import nixpkgs {
	inherit system;
	config.allowUnfree = true;
};

lib = nixpkgs.lib;
in
{
	sahir-nixos-laptop = let
		host = {
			hostName = "sahir-nixos-laptop";
		};
	in lib.nixosSystem {
		inherit system;
		specialArgs = {
			inherit inputs user system host;
		};
		modules = [
			nur.nixosModules.nur
				./laptop
				./configuration.nix

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = {
						inherit user host builtins;
					};
					home-manager.users.${user} = {
						imports = [
							./home.nix
							./laptop/home.nix
						];
					};
				}
		];
	};
}
