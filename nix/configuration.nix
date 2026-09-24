# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the GRUB EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [ "quiet" "splash" "vt.global_cursor_default=0" ];
  # boot.initrd.kernelModules = [ "nvidia" "nvidia-drm" "nvidia-modeset" ];
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        powerManagement.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.displayManager.gdm = {
    enable = true;
  };
  xdg.portal = {
        enable = true;
        wlr.enable = true;
  };
  programs.xwayland.enable = true;
  security.polkit.enable = true;
  services.seatd.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."saanvi" = {
    isNormalUser = true;
    description = "Saanvi";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "audio" "seat" "input" "podman" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
      "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          icon-theme = "Adwaita";
        };
      };
    }
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    package = (pkgs.obs-studio.override { cudaSupport = true; });
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };

  programs.nix-ld.enable = true;

  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    
    # Creates a 'docker' alias so you can use docker commands with podman
    dockerCompat = true; 
    
    # Required for container-to-container communication (e.g. podman-compose)
    defaultNetwork.settings.dns_enabled = true;
  };

  systemd.user.services.mate-polkit-authentication-agent = {
    description = "MATE Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  boot.plymouth = {
    enable = true;
    theme = "bgrt"; # Default NixOS theme
  };
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
      # Terminal
      fzf
      zsh
      zip
      unzip
      ripgrep
      lsd
      ghostty
      starship
      fastfetch
      btop
      playerctl

      # Apps
      vim
      neovim
      stow
      gh
      distrobox
      qpwgraph
      mpv
      steam
      vesktop
      spotify

      # Development
      git
      gcc
      rustc
      cargo
      rustfmt
      rust-analyzer
      clippy
      openjdk25

      # WM
      waybar
      wayvnc
      gnome-themes-extra
      wofi
      mako
      swaybg
      mate-polkit
      pavucontrol
      grim
      slurp
      nautilus
      networkmanagerapplet      

      # Danger Zone
      wayland
      wayland-utils
      (lib.hiPrio nettools)
      (lib.hiPrio coreutils)
      wl-clipboard
      xdg-utils
      wget
      psmisc
      wireplumber
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 5900 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
