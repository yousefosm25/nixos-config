{ pkgs, ... }:
{
  services.tomat = {
    enable = true;

    settings = {
      timer = {
        work = 60;
        break = 15;
        long_break = 30;
      };
      sound = {
        mode = "embedded"; # Sound mode: "embedded", "system-beep", "none"
        volume = 0.5; # Volume level (0.0-1.0)
      };
      notification = {
        enabled = true; # Enable desktop notifications
        icon = "auto"; # Icon mode: "auto", "theme", or custom path
        timeout = 4000; # Notification timeout in milliseconds
      };
      display = {
        text_format = "{icon} {time} {state}";
      };
    };
  };
}
