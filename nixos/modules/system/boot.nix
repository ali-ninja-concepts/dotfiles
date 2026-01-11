{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/27cc1d8e-916e-4704-895f-417b48423465";
    preLVM = true;
    allowDiscards = true;
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  # Required for TPM2 unlock in initrd
  boot.initrd.systemd.enable = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
