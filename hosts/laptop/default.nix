{config, pkgs, user, ... }:
{
	imports = [ ./hardware-configuration.nix ];

	services = {
		blueman.enable = true;
		xserver.libinput.enable = true;
	};
}
