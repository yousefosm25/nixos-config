{ config, pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      foomatic-db
      foomatic-filters
      gutenprint
    ];
  };

  hardware.printers = {
    ensureDefaultPrinter = "NRG_MP_161";
    ensurePrinters = [
      {
        name = "NRG_MP_161";
        location = "Home";
        deviceUri = "usb://NRG/MP%20161?serial=M0178504502";
        model = "foomatic-db/NRG/PS/NRG-MP_161_PS.ppd.gz";
        ppdOptions = {
          PageSize = "A4";
        };

      }
    ];
  };
}
