# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
   hardware.opengl.driSupport32Bit = true;
   hardware.pulseaudio.support32Bit = true;
   nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
   nix.settings = {
        substituters = ["https://nix-gaming.cachix.org"];
        trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-42d44b11-90da-4cbc-ba47-671288244443".device = "/dev/disk/by-uuid/42d44b11-90da-4cbc-ba47-671288244443";
  boot.initrd.luks.devices."luks-42d44b11-90da-4cbc-ba47-671288244443".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaue = {
    isNormalUser = true;
    description = "Kaue";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
    packages = with pkgs; [
      firefox
      brave
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1u"
		"python-2.7.18.6"
              ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  lf
  mc
  neovim
  neofetch
  uwufetch
  nettools
  rustdesk
  remmina 
  wget
  w3m
  dmenu
  neovim
  autojump
  starship
  brave
  bspwm
  cargo
  celluloid
  chatterino2
  clang-tools_9
  #davinci-resolve
  dunst
  elinks
  eww
  feh
  flameshot
  flatpak
  fontconfig
  freetype
  gcc
  gh
  gimp
  git
  github-desktop
  gnugrep
  gnumake
  gparted
  hugo
  kitty
  libverto
  luarocks

  mangohud
  nfs-utils
  ninja
  nodejs
  nomacs
  openssl
  pavucontrol
  picom
  #polkit_gnome
  powershell
  protonup-ng
  python3Full
  python.pkgs.pip
  qemu
  ripgrep
  rofi
  steam
  steam-run
  sxhkd
  st
  stdenv
  synergy
  swaycons
  terminus-nerdfont
  tldr
  trash-cli
  unzip
  variety
  virt-manager
  xclip
  xdg-desktop-portal-gtk
  xfce.thunar
  xorg.libX11
  xorg.libX11.dev
  xorg.libxcb
  xorg.libXft
  xorg.libXinerama
  xorg.xinit
  xorg.xinput
  lutris
	(lutris.override {
	       extraPkgs = pkgs: [
		 # List package dependencies here
		 wineWowPackages.stable
		 winetricks
	                         ];
	                 }
        )

  #  wget
  ];


  ## Gaming
	programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
    virtualisation.libvirtd.enable = true;
  # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.qemuGuest.enable = true;
 
  # enable flatpak support
    services.flatpak.enable = true;
    services.dbus.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
 
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
    system.copySystemConfiguration = true;
    system.autoUpgrade.enable = true;  
    system.autoUpgrade.allowReboot = true; 
    system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

