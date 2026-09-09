{ ... }:

{
  # Lets non-root users mount removable media (udisksctl mount), so
  # scripts like sona-usb.sh don't need sudo.
  services.udisks2.enable = true;
}
