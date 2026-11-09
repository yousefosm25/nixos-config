# hyperdot.nix - Home Manager module: your Hyprland config, declared in Nix
#
# Home Manager builds ~/.config/hypr/hyprland.lua from this file, so the config
# is reproducible and lives in your git repo (it is read-only on disk: edit this
# file, rebuild, then press SUPER + SHIFT + R or run `hyprctl reload`).
# The system side (session entry, portals, packages) stays in hyprland.nix.
#
# This is Hyprland's default config ported to Nix, plus the reload key.
# Needs Hyprland >= 0.56 and a Home Manager that has
# wayland.windowManager.hyprland.configType (26.05 or newer).
#
# Add it in home.nix:   imports = [ ./hyperdot.nix ];
#
# To add a keybind, add a line to `bind` below, for example:
#   (mkBind "${mod} + T" (run "firefox"))
{ lib, pkgs, ... }:

let
  mod = "SUPER";

  # Programs used by the keybinds
  terminal = "kitty";
  fileManager = "dolphin";
  menu = "hyprlauncher";

  # Helpers. A bind is the Lua call hl.bind(keys, dispatcher [, options]).
  lua = lib.generators.mkLuaInline;                 # raw Lua expression
  run = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';     # run a shell command (no double quotes inside)
  mkBind = keys: dsp: { _args = [ keys dsp ]; };
  mkBindWith = keys: dsp: opts: { _args = [ keys dsp opts ]; };

  # Options for volume/brightness/media keys (work on the lock screen)
  repeatOpts = { locked = true; repeating = true; };
  lockedOpts = { locked = true; };

  # Shortcuts for hl.curve / hl.animation
  bezier = name: p1: p2: { _args = [ name { type = "bezier"; points = [ p1 p2 ]; } ]; };
  anim = leaf: attrs: { inherit leaf; enabled = true; } // attrs;
in
{
  assertions = [
    {
      assertion = lib.versionAtLeast pkgs.hyprland.version "0.56";
      message = "hyperdot.nix writes a Lua config, which needs Hyprland >= 0.56 (found ${pkgs.hyprland.version}).";
    }
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;          # Hyprland itself is installed by hyprland.nix
    portalPackage = null;
    systemd.enable = false;  # UWSM manages the session, so Home Manager's systemd hook must be off
    configType = "lua";

    settings = {
      # ---- Monitors ----
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

      # ---- Environment variables ----
      env = [
        { _args = [ "XCURSOR_SIZE" "24" ]; }
        { _args = [ "HYPRCURSOR_SIZE" "24" ]; }
      ];

      # ---- Look and feel, input, layouts ----
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          col = {
            active_border = { colors = [ "rgba(33ccffee)" "rgba(00ff99ee)" ]; angle = 45; };
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;  # true: resize windows by dragging borders and gaps
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = lua "0xee1a1a1a";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;
        master.new_status = "master";
        scrolling.fullscreen_on_one_column = true;

        misc = {
          force_default_wallpaper = -1;   # 0 or 1 turns off the anime mascot wallpapers
          disable_hyprland_logo = false;
        };

        layers.allow_new_top_layers_over_existing_fullscreen = true;

        input = {
          kb_layout = "us";               # two layouts: "us,ara" plus kb_options = "grp:alt_shift_toggle"
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          sensitivity = 0;                # -1.0 to 1.0, 0 means no change
          touchpad.natural_scroll = false;
        };
      };

      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };

      # ---- Animations ----
      curve = [
        (bezier "easeOutQuint" [ 0.23 1 ] [ 0.32 1 ])
        (bezier "easeInOutCubic" [ 0.65 0.05 ] [ 0.36 1 ])
        (bezier "linear" [ 0 0 ] [ 1 1 ])
        (bezier "almostLinear" [ 0.5 0.5 ] [ 0.75 1 ])
        (bezier "quick" [ 0.15 0 ] [ 0.1 1 ])
        { _args = [ "easy" { type = "spring"; mass = 1; stiffness = 238.1191; damping = 24.21279333; } ]; }
      ];

      animation = [
        (anim "global" { speed = 10; bezier = "default"; })
        (anim "border" { speed = 5.39; bezier = "easeOutQuint"; })
        (anim "windows" { speed = 4.79; spring = "easy"; })
        (anim "windowsIn" { speed = 4.1; spring = "easy"; style = "popin 87%"; })
        (anim "windowsOut" { speed = 1.49; bezier = "linear"; style = "popin 87%"; })
        (anim "fadeIn" { speed = 1.73; bezier = "almostLinear"; })
        (anim "fadeOut" { speed = 1.46; bezier = "almostLinear"; })
        (anim "fade" { speed = 3.03; bezier = "quick"; })
        (anim "layers" { speed = 3.81; bezier = "easeOutQuint"; })
        (anim "layersIn" { speed = 4; bezier = "easeOutQuint"; style = "fade"; })
        (anim "layersOut" { speed = 1.5; bezier = "linear"; style = "fade"; })
        (anim "fadeLayersIn" { speed = 1.79; bezier = "almostLinear"; })
        (anim "fadeLayersOut" { speed = 1.39; bezier = "almostLinear"; })
        (anim "workspaces" { speed = 1.94; bezier = "almostLinear"; style = "fade"; })
        (anim "workspacesIn" { speed = 1.21; bezier = "almostLinear"; style = "fade"; })
        (anim "workspacesOut" { speed = 1.94; bezier = "almostLinear"; style = "fade"; })
        (anim "zoomFactor" { speed = 7; bezier = "quick"; })
      ];

      # ---- Keybindings ----
      bind = [
        (mkBind "${mod} + Q" (run terminal))
        (mkBind "${mod} + C" (lua "hl.dsp.window.close()"))
        (mkBind "${mod} + M" (run "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
        (mkBind "${mod} + E" (run fileManager))
        (mkBind "${mod} + V" (lua ''hl.dsp.window.float({ action = "toggle" })''))
        (mkBind "${mod} + R" (run menu))
        (mkBind "${mod} + P" (lua "hl.dsp.window.pseudo()"))
        (mkBind "${mod} + J" (lua ''hl.dsp.layout("togglesplit")''))  # dwindle only

        # Reload this config after a rebuild
        (mkBind "${mod} + SHIFT + R" (run "hyprctl reload config-only"))

        # Move focus with mod + arrow keys
        (mkBind "${mod} + left" (lua ''hl.dsp.focus({ direction = "left" })''))
        (mkBind "${mod} + right" (lua ''hl.dsp.focus({ direction = "right" })''))
        (mkBind "${mod} + up" (lua ''hl.dsp.focus({ direction = "up" })''))
        (mkBind "${mod} + down" (lua ''hl.dsp.focus({ direction = "down" })''))

        # Special workspace (scratchpad)
        (mkBind "${mod} + S" (lua ''hl.dsp.workspace.toggle_special("magic")''))
        (mkBind "${mod} + SHIFT + S" (lua ''hl.dsp.window.move({ workspace = "special:magic" })''))

        # Scroll through existing workspaces with mod + scroll
        (mkBind "${mod} + mouse_down" (lua ''hl.dsp.focus({ workspace = "e+1" })''))
        (mkBind "${mod} + mouse_up" (lua ''hl.dsp.focus({ workspace = "e-1" })''))

        # Move/resize windows with mod + left/right mouse button and dragging
        (mkBindWith "${mod} + mouse:272" (lua "hl.dsp.window.drag()") { mouse = true; })
        (mkBindWith "${mod} + mouse:273" (lua "hl.dsp.window.resize()") { mouse = true; })

        # Laptop multimedia keys for volume and brightness
        (mkBindWith "XF86AudioRaiseVolume" (run "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") repeatOpts)
        (mkBindWith "XF86AudioLowerVolume" (run "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") repeatOpts)
        (mkBindWith "XF86AudioMute" (run "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") repeatOpts)
        (mkBindWith "XF86AudioMicMute" (run "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") repeatOpts)
        (mkBindWith "XF86MonBrightnessUp" (run "brightnessctl -e4 -n2 set 5%+") repeatOpts)
        (mkBindWith "XF86MonBrightnessDown" (run "brightnessctl -e4 -n2 set 5%-") repeatOpts)

        # Media keys (need playerctl)
        (mkBindWith "XF86AudioNext" (run "playerctl next") lockedOpts)
        (mkBindWith "XF86AudioPause" (run "playerctl play-pause") lockedOpts)
        (mkBindWith "XF86AudioPlay" (run "playerctl play-pause") lockedOpts)
        (mkBindWith "XF86AudioPrev" (run "playerctl previous") lockedOpts)
      ]
      # Switch workspaces with mod + [0-9], move the active window with mod + SHIFT + [0-9]
      ++ lib.concatMap (i:
        let key = toString (lib.mod i 10);  # workspace 10 sits on key 0
        in [
          (mkBind "${mod} + ${key}" (lua "hl.dsp.focus({ workspace = ${toString i} })"))
          (mkBind "${mod} + SHIFT + ${key}" (lua "hl.dsp.window.move({ workspace = ${toString i} })"))
        ]
      ) (lib.range 1 10);

      # ---- Window rules ----
      window_rule = [
        {
          # Ignore maximize requests from all apps
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          # Fix some dragging issues with XWayland
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
        {
          name = "move-hyprland-run";
          match.class = "hyprland-run";
          move = "20 monitor_h-120";
          float = true;
        }
      ];
    };
  };
}
