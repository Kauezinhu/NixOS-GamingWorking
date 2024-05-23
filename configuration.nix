# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = [ "ntfs" ];      
    extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

    loader = {
      efi = {
       canTouchEfiVariables = true;
       efiSysMountPoint = "/boot";
      };
      grub = {
      enable = true;
      #version = 2;
      devices = ["nodev"];
      useOSProber = true;
      efiSupport = true;
      configurationLimit = 5;
      };
      timeout = 8;
    };
  };

############# Gaming Configs ######
                                  #
  hardware.opengl = {             #
     enable = true;               #
     driSupport = true;           #
     driSupport32Bit = true;      #
     extraPackages = with pkgs; [ #
        #intel-media-driver       #
        vaapiVdpau                #
        libvdpau-va-gl            #
     ];                           #
   };                             #
   
  # Mouse Config LogitechG
  services.ratbagd.enable = true;

  

  programs.steam = {
	enable = true;
	   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        };

###################################

   nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
   nix.settings = {
        substituters = ["https://nix-gaming.cachix.org"];
        trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };


  networking.hostName = "NixOS_Desktop"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
  #services.xserver.enable = true;
  #services.xserver.videoDrivers = ["amdgpu"];

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services = {
         xserver = {
                   enable = true;
                   
                   xkb.variant = "";
                   xkb.layout = "br";
                   videoDrivers = ["amdgpu"];
                   displayManager = {
                                  sddm.enable = true;
                                  #sddm.theme = "";
                                  #sddm.setupScript = "";
                                  #sddm.settings {}; 
                                  defaultSession = "plasmawayland";
                   };
                   desktopManager = {
                                  plasma5.enable = true;
                   };
                   windowManager.awesome = {
                                         enable = true;
					                               luaModules = with pkgs.luaPackages; [
                                                    #luarocks # is the package manager for lua modules
						                                        #luadbi-mysql #database
					                               ];
                   };  
         };
 };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
  	gwenview
  	okular
  	oxygen
  	khelpcenter
  	konsole
  	plasma-browser-integration
  	print-manager
  ];


  programs.dconf.enable = true;


  # Configure keymap in X11
  #services.xserver = {
  #  layout = "br";
  #  Variant = "";
  #};

  # Configure console keymap
  console.keyMap = "br-abnt2";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  hardware.pulseaudio.support32Bit = true;
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
  #Bluethoth Configuration
   hardware.bluetooth.enable = true;
   #services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaue = {
    isNormalUser = true;
    description = "Kaue";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" "video" "audio" "lp" "scanner" "transmission" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.permittedInsecurePackages = [
  #             "openssl-1.1.1w"                

	#	"python-2.7.18.6"
  #            ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

  ### SYSTEM CORE PKGS
  wget
  killall
  zip
  unzip
  #blueman
  bluez
  flatpak
  gparted
  wine-staging
  nvd

  ### Files Support
  ntfs3g    #/.NTFS with write support
  nfs-utils
  cifs-utils
  lxqt.lxqt-policykit

  ### Text Editors
  vim
  neovim
  neovide
  
  ### Gaming
  corectrl
  duckstation
  #yuzu-early-access
  rpcs3
  #cemu #erro de Dependencies no bleading edge
  piper
  libratbag
  steam
  steam-run
  steamcmd
  protonup-ng
  protonup-qt
  mangohud
  bottles
  winetricks
  playonlinux
  r2modman
  steamtinkerlaunch
  xdotool
  xorg.xwininfo
  yad
  lutris
	(lutris.override {
	       extraPkgs = pkgs: [
		 # List package dependencies here
		 #wineWowPackages.stagingFull
		 winetricks
	                         ];
	                 }
        )


  ### Gaming Extras & Dependencies
  
  gnugrep
  bash
  gnused
  sqlite
  xdg-utils
  coreutils  
  findutils 

  ### Helpdeks IT Tools
  rustdesk
  anydesk
  teamviewer
  parsec-bin
  remmina
  filezilla
  winbox
  bitwarden

  ### Terminal f(x)
  alacritty
  kitty
  mc
  ncdu
  lf
  broot
  tldr
  neofetch
  uwufetch
  nettools
  htop
  putty
  inetutils
  cmatrix
  rsync
  w3m
  browsh
  autojump
  trash-cli
  bat
  feh
  eza
  tmux
  ydotool
  cava
  lolcat
  lsd
  terminus-nerdfont
  ripgrep
  openssh

  ### Default Applications
  brave #/.browser  
  xfce.thunar #/.fileBrowser
  xfce.thunar-volman 
  pcmanfm
  gnome.gvfs #/.remotemount extension for thunar
  vlc #/.VideoCodec
  transmission #/. BitTorrent Client
  transmission-gtk
  discord #/.Its a crime to own this in my country
  gimp #/.Fuck Photoshop


  ### Virtualization GOD
  docker-compose
  qemu
  virt-manager

  ### Quality of Life Desktop
  flameshot #/.screenshot
  sxhkd #/.Hotkey Daemon

  ### Programming
  gh
  git
  github-desktop

  
  ### windowManager dependencies
  awesome
  picom-next
  rofi
  luajitPackages.luarocks 
  rofi-calc
  rofi-emoji
  rofi-bluetooth
  rofi-power-menu
  #mpc
  #mpd
  #scrot
  #xorg.xbacklight
  #xsel

  xclip
  dunst
  nitrogen




  starship
  #bspwm
  #cargo
  celluloid
  chatterino2
  #clang-tools_9
  #davinci-resolve
  eww
  fontconfig
  font-manager
  freetype
  #gcc
  gnumake
  libverto
  luarocks
  ninja
  nodejs
  nomacs
  openssl
  pavucontrol
  #polkit_gnome
  powershell
  #python3Full
  #python.pkgs.pip

  ### CRYPTo ###
  monero-gui
  xmrig


  ];

    #atualizaçoes de app como discord 
       nixpkgs.overlays= [
  
   (self: super: {
          discord = super.discord.overrideAttrs (
          _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
       sha256 = "0pml1x6pzmdp6h19257by1x5b25smi2y60l1z40mi58aimdp59ss";
          }; }
          );
   })
   (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libgdiplus
        ]);
      });
    })

  ];




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
  
  # Enable Automounting Drives
    services.udisks2.enable = true;
    services.devmon.enable = true; 
    services.gvfs.enable = true;

  # BitTorrent program as a service
    services.transmission.enable = true;            

  # Teamviewer 
    services.teamviewer.enable = true ;

  # enable flatpak support
    services.flatpak.enable = true;
    services.dbus.enable = true;
    
    #xdg.portal = {
     #  enable = true;
      # wlr.enable = true;
       #gtk portal needed to make gtk apps happy
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #};

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
    system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable nixos";
    
    nix = {
      gc = {
       automatic = true;
       dates = "weekly";
       options = "--delete-older-than 7d";
       };
    };    

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
}

