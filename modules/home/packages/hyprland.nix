{ host, lib, ... }:

{
  # home.packages = with pkgs; [ ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swayidle -w timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
        "swww init"
        "swaync"
        # "waybar" # already started
      ];

      monitor = lib.mkIf (!host.is_vm) ",highres,auto,1";

      input = {
        kb_layout = "es";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };

      general = {
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
        "gaps_in" = 6;
        "gaps_out" = 8;
        "col.active_border" = "rgba(bb9af7ff) rgba(b4f9f8ff) 45deg";
        "col.inactive_border" = "rgba(565f89cc) rgba(9aa5cecc) 45deg";
      };

      decoration = {
        rounding = 10;
        drop_shadow = false;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = "on";
          ignore_opacity = "on";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      master = {
        new_is_master = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = [
        "float, ^(steam)$"
        "center, ^(steam)$"
        "size 1080 900, ^(steam)$"
      ];

      "$mod" = if (host.is_vm) then "CONTROL_SHIFT" else "SUPER";
      bind = [
        # launcher
        "$mod,Space,exec,rofi -show drun"

        "$mod,W,exec,${if (host.user.pref.browser != "") then host.user.pref.browser else "luakit" }"
        "$mod,T,exec,${if (host.user.pref.terminal != "") then host.user.pref.terminal else "wezterm" }"
        "$mod SHIFT,S,exec,wallsetter"

        "$mod,P,pseudo," # pseudo tiling
        "$mod,Q,killactive,"

        # xf86 key
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10));

      bindm = [
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow"
      ];

    };
  };
}
