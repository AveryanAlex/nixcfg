{
  config,
  lib,
  ...
}:
{
  security.rtkit.enable = lib.mkDefault config.services.pipewire.enable;

  services.pipewire = {
    enable = lib.mkDefault config.nixcfg.desktop;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    extraConfig.pipewire."99-low-latency" = {
      "context.properties" = {
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 1024;
      };
    };
  };

  services.pulseaudio.enable = lib.mkIf config.services.pipewire.enable false;

  hm.services.mpd.extraConfig = lib.mkIf config.services.pipewire.enable ''
    audio_output {
      type "pipewire"
      name "PipeWire"
    }
  '';
}
