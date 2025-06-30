{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GNOME.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.gnome.core-shell.enable = true;
  #services.gnome.gnome-keyring.enable = true;
  #services.gvfs.enable = true;
  # Optional: disable extra gnome utilities
  #services.gnome.core-apps.enable = false;  

  # Enable KDE.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Flatpak.
  services.flatpak.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable QEMU/KVM
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Enable OpenRGB
  services.udev.packages = [ pkgs.openrgb ];

  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd"; 
  };

  services.dbus.enable = true;
}
