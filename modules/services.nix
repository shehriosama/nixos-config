{ ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GNOME.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-shell.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  # Optional: disable extra gnome utilities
  services.gnome.core-apps.enable = false;  

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
}
