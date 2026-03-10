{
  config,
  pkgs,
  lib,
  ...
}: {
  options.nixcfg.gnome = {
    enable = lib.mkEnableOption "the GNOME desktop configurations";
  };

  config = lib.mkIf config.nixcfg.gnome.enable {
    nixcfg.desktop = true;
    
  services.xserver = {
    enable = lib.mkDefault false;
    
    xkb.layout = lib.mkIf (config.i18n.defaultLocale == "ru_RU.UTF-8") (lib.mkDefault "us,ru");
    xkb.options = lib.mkDefault "grp:win_space_toggle";
    
    excludePackages = lib.mkDefault [pkgs.xterm];
  };

    services.displayManager.gdm.enable = lib.mkDefault true;
    services.desktopManager.gnome.enable = lib.mkDefault true;

    environment.gnome.excludePackages = lib.mkDefault (with pkgs; [
      gnome-tour
      epiphany
    ]);

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = lib.mkDefault "1";
      # NIXOS_OZONE_WL = lib.mkDefault "1";
    };
  };
}
