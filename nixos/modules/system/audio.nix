{ ... }:

{
  # Audio via PipeWire (modern replacement for PulseAudio)
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
}
