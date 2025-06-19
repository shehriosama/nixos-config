{ config, lib, pkgs, inputs, ... }:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "i2c-dev" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Riyadh";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  hardware.i2c.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.osama = {
    isNormalUser = true;
    description = "Osama";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # GNOME Apps
    file-roller
    gnome-disk-utility
    gnome-shell-extensions
    adwaita-icon-theme
    # nixos-background-info
    gnome-backgrounds
    gnome-bluetooth
    gnome-color-manager
    gnome-control-center
    gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    glib # for gsettings program
    xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    xdg-user-dirs-gtk # Used to create the default bookmarks
    baobab
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-weather
    loupe
    nautilus
    gnome-connections
    simple-scan
    snapshot
    gnome-software
    dconf-editor
    gnome-tweaks
    mission-center
    # Services
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    gnome-keyring
    gvfs

    # Virtualization
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-vdagent
    spice-protocol
    virtio-win
    win-spice
    swtpm

    # System tools
    home-manager
    distrobox
    podman
    nvidia-container-toolkit
    i2c-tools

    # Development Tools
    # C/C++
    libgcc
    gdb
    cmake
    gnumake

    # Theming for GTK/GNOME applications
    adw-gtk3
    gtk-engine-murrine
    gnome-themes-extra
    sassc
    morewaita-icon-theme
    
    # Adwaita for Qt applications (CRUCIAL for GNOME integration)
    adwaita-qt      # For Qt5 apps
    adwaita-qt6     # For Qt6 apps

    # Qt configuration tools and necessary plugins
    libsForQt5.qtstyleplugins 	      # General Qt5 style plugins
    libsForQt5.qt5.qtbase             # Qt5 base libraries
    libsForQt5.qtstyleplugin-kvantum  # Qt5 Kvantum
    kdePackages.qtbase        	      # Qt6 base libraries
    kdePackages.qt6ct                 # Qt6 configuration tool
    kdePackages.qt6gtk2       	      # Qt6 GTK2 style plugin (helps with GTK integration)
    kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum


    # CLI Tools
    # Powerful
    zsh
    git
    ripgrep
    bat
    tmux
    fzf
    fd    
    # Basics
    neovim
    vim
    wget
    curl
    git
    nano
    tree
    zsh
    btop
    fastfetch
    unzip
    unrar

    # Daily Apps
    brave
    kitty
    ghostty
    persepolis
    openrgb
    openrgb-with-all-plugins
    mpv
    blender
    emacs-pgtk
    # Office Apps
    thunderbird
    evince
    kdePackages.okular
    libreoffice
    hunspell
    hplip
    system-config-printer    

    # Important packages
    flatpak
    libwacom
  ];

  fonts.packages = with pkgs; [
    # Microsoft fonts
    corefonts
    vistafonts
    # Noto fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    # Nerd fonts
    nerd-fonts.zed-mono
    nerd-fonts.fira-code
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.lilex
    nerd-fonts.space-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    # Other fonts
    amiri
    go-font
    font-awesome
  ];

  fonts.fontconfig.enable = true;

  environment.variables = {
    XCURSOR_THEME = "Adwaita"; # Or your desired theme
    XCURSOR_SIZE = "24";       # Optional, default size is 24
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Direct Qt to use qt6ct for platform theming
    QT_QPA_PLATFORM = "wayland;xcb"; # Prefer Wayland but fall back to X11 (Good setting)
  };

  programs.firefox.enable = true;

  # ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Virtualization
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        vhostUserPackages = with pkgs; [ virtiofsd ];
        # Enable TPM emulation (optional)
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    # Enable USB redirection (optional)
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;



  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  environment.shells = with pkgs; [ zsh ];
  system.stateVersion = "25.05";

}

