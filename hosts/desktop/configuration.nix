{ config, lib, pkgs, inputs, ... }:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.overlays = [inputs.blender-bin.overlays.default];

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
    extraPackages = with pkgs; [
      mesa
      rocmPackages.clr.icd
      libva
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      amdvlk  # Optional: AMD's proprietary Vulkan driver
      mesa.opencl  # Enables Rusticl (OpenCL) support
      libGL
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
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
    nvidia-container-toolkit
    ocl-icd
    cudaPackages.cudatoolkit
    i2c-tools
    clinfo
    vulkan-tools
    mesa-demos

    # Development Tools
    # C/C++
    libgcc
    gdb
    cmake
    gnumake

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
    appmenu-glib-translator
    
    # Adwaita for Qt applications (CRUCIAL for GNOME integration)
    adwaita-qt      # For Qt5 apps
    adwaita-qt6     # For Qt6 apps

    # Qt configuration tools and necessary plugins
    libsForQt5.qtstyleplugins 	      # General Qt5 style plugins
    libsForQt5.qt5.qtbase             # Qt5 base libraries
    libsForQt5.qtstyleplugin-kvantum  # Qt5 Kvantum
    kdePackages.qtbase        	      # Qt6 base libraries
    #kdePackages.qt6ct                 # Qt6 configuration tool
    #kdePackages.qt6gtk2       	      # Qt6 GTK2 style plugin (helps with GTK integration)
    kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum
    darkly

    # KDE
    kdePackages.kdeconnect-kde
    kde-rounded-corners
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.partitionmanager
    kdePackages.sddm-kcm
    kdePackages.kdevelop
    kdePackages.korganizer

    # GNOME
    gnome-disk-utility

    # CLI Tools
    # Powerful
    zsh
    atuin
    git
    ripgrep
    bat
    tmux
    fzf
    fd    
    delta
    eza
    tldr
    zoxide
    vscode-fhs
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
    # ghostty
    persepolis
    openrgb
    openrgb-with-all-plugins
    mpv
    emacs-pgtk
    qalculate-qt
    # Office Apps
    thunderbird
    evince
    kdePackages.okular
    libreoffice-fresh
    hunspell
    hplip
    system-config-printer    
    strawberry
    # Studio Softwares
    davinci-resolve
    # blender
    blender_4_4
    audacity

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
    podman = {
      enable = true;
      extraPackages = with pkgs; [ nvidia-container-toolkit ];
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
