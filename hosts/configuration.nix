{ config, lib, pkgs, inputs, user, host, ... }:
let 
  mPolybar = pkgs.polybar.override {
    i3Support = true;
    alsaSupport = true;
    githubSupport = true;
    pulseSupport = true;
  };
  myEmacsClientSrc = builtins.readFile ./dotfiles/shellScripts/emacsClientLauncher;
  myEmacsClient = (pkgs.writeScriptBin "emc" myEmacsClientSrc).overrideAttrs(old: {
  	buildCommands = "${old.buildCommand}\n patchShebangs $out";
  });
in {

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
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "${host.hostName}";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  hardware = {
    opengl.enable = true;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    nvidia = {
      modesetting = {
        enable = true;
      };
      nvidiaSettings = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = ["nvidia"];

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        sddm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3lock
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
    emacs = {
      enable = false;
      package = pkgs.emacs-unstable;
    };
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
            };
          };
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [
    wget
    curl
    pulseaudio
    blueman
    zip
    unzip
    rofi
    mPolybar
    dracula-theme
    lxappearance
    dunst
    vlc
    libreoffice
    myEmacsClient
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
    udevil.enable = true;
  };

  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  fonts.packages = with pkgs; [                # Fonts
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
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = { 
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
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
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11"; 
  };
}
