{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;  # RTX 50xx series requires open kernel modules
    nvidiaSettings = true;
    # Pinned: locked nixpkgs ships 595.84, which causes DP link drops on
    # second monitor (Xorg log DFP-1 disconnect/reconnect flaps). Trying
    # 595.91.07 from nixpkgs master; if flap returns, fall back to known
    # driver 595.58.03 (hashes in git history). Unpin once locked nixpkgs
    # ships >= 595.91.07.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.91.07";
      sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
      sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
      openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
      settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
      persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
