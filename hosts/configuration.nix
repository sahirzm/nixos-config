{ config, lib, pkgs, inputs, user, host, ... }:
{

	users.users.${user} = {
		isNormalUser = true;
		extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" ];
		shell = pkgs.zsh;
	};
	security.sudo.wheelNeedsPassword = false;

	environment.pathsToLink = [ "/libexec" ];

# Use the systemd-boot EFI boot loader.
	boot.loader = {
		systemd-boot = {
			enable = true;
			configurationLimit = 5;
		};
		efi.canTouchEfiVariables = true;
	};

	networking.hostName = "${host.hostName}";
	networking.networkmanager.enable = true;

	time.timeZone = "America/Toronto";

	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	services = {
		xserver = {
			enable = true;
			layout = "us";

			desktopManager = {
				xterm.enable = false;
				# plasma5.enable = true;
			};

			displayManager = {
				defaultSession = "none+i3";
				# sddm.enable = true;
			};

			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu
						i3status
						i3lock
						i3blocks
				];
			};
		};
		printing.enable = true;
		pipewire = {
			enable = true;
			alsa = {
				enable = true;
			};
			pulse.enable = true;
			jack.enable = true;
		};
		openssh.enable = true;
	};
	environment.systemPackages = with pkgs; [
		wget
			lxappearance
	];

	programs = {
		neovim = {
			enable = true;
			viAlias = true;
			vimAlias = true;
		};
		zsh = {
			enable = true;
		};
	};


	fonts.fonts = with pkgs; [                # Fonts
		carlito                                 # NixOS
		vegur                                   # NixOS
		source-code-pro
		jetbrains-mono
		font-awesome                            # Icons
		corefonts                               # MS
		(nerdfonts.override {                   # Nerdfont Icons override
		 fonts = [
		 "FiraCode"
		 ];
		 })
	];

	nix = {
		settings ={
			auto-optimise-store = true;
		};
		gc = { 
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 2d";
		};
		package = pkgs.nixVersions.unstable;
		registry.nixpkgs.flake = inputs.nixpkgs;
		extraOptions = ''
			experimental-features = nix-command flakes
			keep-outputs          = true
			keep-derivations      = true
			'';
	};
	nixpkgs.config.allowUnfree = true;
	system = {
		autoUpgrade = {
			enable = true;
			channel = "https://nixos.org/channels/nixos-unstable";
		};
		stateVersion = "22.11"; 
	};
}

