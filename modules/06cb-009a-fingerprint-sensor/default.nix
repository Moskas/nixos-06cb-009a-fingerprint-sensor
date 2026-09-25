{config, lib, libfprint-2-tod1-vfs0090-bingch, localPackages, ...}:

let
  cfg = config.services.fingerprint06cb009a;
  wrapModule = import ../../lib/wrapModule.nix;
in

with lib;

{
  imports = [
    (wrapModule { inherit localPackages; } ../python-validity)
    ../open-fprintd
  ];

  options = {
    services.fingerprint06cb009a = {
      enable = mkOption {
        default = false;
        type = with types; bool;
      };

      backend = mkOption {
        default = "python-validity";
        type = with types; enum [
          "python-validity"
          "libfprint-tod"
        ];
      };

      calibDataFile = mkOption {
        type = with types; path;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.backend == "python-validity") {
      services.open-fprintd.enable = true;
      services.python-validity.enable = true;

      # this backend replaces the stock fprintd service with open-fprintd
      services.fprintd.enable = false;
    })

    (mkIf (cfg.backend == "libfprint-tod") {
      services.open-fprintd.enable = false;
      services.python-validity.enable = false;

      services.fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = libfprint-2-tod1-vfs0090-bingch {
            calib-data-file = cfg.calibDataFile;
          };
        };
      };
    })
  ]);
}
