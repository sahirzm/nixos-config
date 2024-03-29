# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.extraModulePackages = [ ];
  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/df5e6764-4761-4e0a-b8ed-4f8a223187c2";
      preLVM = true;
    };
  };
  fileSystems."/" =
  { device = "/dev/disk/by-uuid/3e22133a-5f2c-4684-9c9c-aaa552629512";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/65A5-5070";
    fsType = "vfat";
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/97ec6bfb-39d2-4618-9c5f-9d91ba1fd954"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
