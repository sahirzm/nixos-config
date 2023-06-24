{config, pkgs, user, ... }:
{
	imports = [ ./hardware-configuration.nix ];

	services = {
		blueman.enable = true;
	};

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };
  };

}
