{ config, lib, pkgs, inputs, user, host, ... }:
{

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" ];
    shell = pkgs.zsh;
  };
  security = {
    sudo =  {
      wheelNeedsPassword = false;
    };
    polkit = {
      enable = true;
    };
  };

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
      enable = false;
      layout = "us";

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = false;
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
    blueman.enable = true;
  };
  environment.systemPackages = with pkgs; [
    wget
      lxappearance
      wayland
      grim # screenshot
      slurp # screenshot
      wl-clipboard
      dunst # notifications daemon
      waybar-hyprland
      wofi
      pulseaudio
      blueman
      wpaperd
      light # adjust backlight brightness

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
    hyprland = {
      enable = true;
      nvidiaPatches = true;
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
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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

