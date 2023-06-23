{config, pkgs, user, ... }:
{
	imports = [ ./hardware-configuration.nix ];

	services = {
		blueman.enable = true;
	};

}
