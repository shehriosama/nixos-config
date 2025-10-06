{ config, pkgs, ... }:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

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

  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      mesa
      rocmPackages.clr.icd
      libva
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      mesa.opencl  # Enables Rusticl (OpenCL) support
      libGL
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.osama = {
    isNormalUser = true;
    description = "Osama Al-Shehri";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme

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
    ocl-icd
    i2c-tools
    clinfo
    vulkan-tools
    mesa-demos

    # Development Tools
    # C/C++
    libgcc
    gcc
    gdb
    cmake
    gnumake
    # Go
    go
    gopls
    # Rust
    rustc
    rust-analyzer
    cargo
    clippy
    # Python
    python313
    pyright

    # Theming dependencies
    dconf-editor
    gtk3
    gtk2
    gtk-engine-murrine
    gnome-themes-extra
    sassc
    libxml2
    glib
    # glibc

    # Theming for GTK/GNOME applications
    adw-gtk3
    morewaita-icon-theme
    # appmenu-glib-translator
    
    # Adwaita for Qt applications (CRUCIAL for GNOME integration)
    adwaita-qt      # For Qt5 apps
    adwaita-qt6     # For Qt6 apps

    # Qt configuration tools and necessary plugins
    libsForQt5.qtstyleplugins 	      # General Qt5 style plugins
    libsForQt5.qt5.qtbase             # Qt5 base libraries
    #libsForQt5.qtstyleplugin-kvantum  # Qt5 Kvantum
    kdePackages.qtbase        	      # Qt6 base libraries
    kdePackages.qt6ct                 # Qt6 configuration tool
    kdePackages.qt6gtk2       	      # Qt6 GTK2 style plugin (helps with GTK integration)
    #kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum
    kdePackages.breeze
    kdePackages.breeze-gtk

    # GNOME Apps
    gnome-disk-utility
    gnome-text-editor
    gnome-tweaks
    snapshot
    baobab
    gnome-characters
    gnome-connections
    gnome-keyring
    gnome-calculator
    nautilus
    loupe
    file-roller
    gnome-calendar
    gnome-weather
    gnome-clocks
    gnome-font-viewer
    gnome-logs
    # GNOME Circle
    mission-center
    planify
    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
    gnomeExtensions.lock-keys
    gnomeExtensions.logo-menu
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.status-area-horizontal-spacing
    gnomeExtensions.tiling-assistant
    gnomeExtensions.tweaks-in-system-menu
    gnomeExtensions.wiggle
    gnomeExtensions.wireless-hid

    # CLI Tools
    # Powerful
    zsh
    atuin
    git
    ripgrep
    bat
    fzf
    fd    
    delta
    eza
    tldr
    zoxide
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
    ghostty
    persepolis
    obsidian
    mpv
    discord
    # Office Apps
    papers
    kdePackages.okular
    libreoffice-fresh
    hunspell
    # hplip
    hplipWithPlugin
    system-config-printer    
    # Studio Softwares
    blender
    # blender_4_4
    audacity

    # Important packages
    # flatpak
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
    inter
    adwaita-fonts
    amiri
    go-font
    font-awesome
  ];

  fonts.fontconfig.enable = true;

  #environment.variables = {
  #  XCURSOR_THEME = "Adwaita"; # Or your desired theme
  #  XCURSOR_SIZE = "24";       # Optional, default size is 24
  #  QT_QPA_PLATFORMTHEME = "qt6ct"; # Direct Qt to use qt6ct for platform theming
  #  QT_QPA_PLATFORM = "wayland;xcb"; # Prefer Wayland but fall back to X11 (Good setting)
  #};

  # Run non-nix executables
  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add any missing dynamic libraries for unpackaged programs
  #   # here, NOT in environment.systemPackages
  # ];

  programs.firefox.enable = true;

  # ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Virtualization
  # programs.virt-manager.enable = true;
  # virtualisation = {
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       vhostUserPackages = with pkgs; [ virtiofsd ];
  #       # Enable TPM emulation (optional)
  #       swtpm.enable = true;
  #       ovmf.enable = true;
  #       ovmf.packages = [ pkgs.OVMFFull.fd ];
  #     };
  #   };
  #   podman = {
  #     enable = true;
  #   };
  #   # Enable USB redirection (optional)
  #   spiceUSBRedirection.enable = true;
  # };
  # services.spice-vdagentd.enable = true;
  # services.qemuGuest.enable = true;


  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  environment.shells = with pkgs; [ zsh ];
  system.stateVersion = "25.05";

}
