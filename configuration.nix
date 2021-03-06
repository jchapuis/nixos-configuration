# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./desktop-environments
      ./basics
      ./apps
      ./dev
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable fish shell
  programs.fish.enable = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
 
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  nixpkgs.config.allowUnfree = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

   # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      symbola
      ubuntu_font_family
      unifont
      vistafonts
    ];
  }; 

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jchapuis = {
     isNormalUser = true;
     extraGroups = [
      "audio" "disk" "docker" "networkmanager" "plugdev"
      "systemd-journal" "wheel" "vboxusers" "video"
      ];
     uid = 1000;
     shell = "/run/current-system/sw/bin/fish";
     openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHXTfECHVwgkguyvPB1Dn8cf3hgsUs4Q087YbtXL8ehXTZKBln6BhOPBO6FwVjRn/yDvyANpB9VRCOBbfOOtRYh12QoG4WYHtv+g9Y/r6vdu9LCkfUWUSFs9YRHLco92NDdj+AD2f4V+G502EkIOwAegtyj1u9QfaRnFf+QM7ytJAMeRDweWxsr6gfd8E67X/5EQtdnXGBBotovy5Hz65ku+2w8EyqgjfPs4iVEHkcaeXipBA/hFlh60/bmhHmRhh1w2LPRhKSP7Y7LdrMyxJQQtXsZNlfPhtYLzwMrm7n44oxe60+e1qUyHtbFjn0aysNijF+cIa4xWXBQ5ltJjV/ jonas.chapuis@nexthink.com"
    ];
   };

  # Enable manual on virtual console 8
  services.nixosManual.showManual = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos-jchapuis"; 

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

  boot.initrd.luks.devices = [
  {
    name = "root";
    device = "/dev/sda3";
    preLVM = true;
  }
  ];

  boot.loader.grub.device = "/dev/sda";
}
