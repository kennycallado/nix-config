{ host, lib, ... }:

{
  # home.packages = with pkgs; [ ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # ???
        "swayidle -w timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
        "dbus-update-activation-environment --systemd --all"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swww init"
        "swaync"
        "waybar"
      ];

      monitor = lib.mkIf (!host.config.is_vm) ",highres,auto,1";

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
        # for now
        # "float, ^(steam)$"
        # "center, ^(steam)$"
        # "size 1080 900, ^(steam)$"
      ];

      "$mod" = if (host.config.is_vm) then "CONTROL_SHIFT" else "SUPER";
      bind = [
        # launcher
        "$mod,Space,exec,rofi -show drun"
        "$mod SHIFT,Space,exec,rofi -show power-menu -modi power-menu:rofi-power-menu"

        # exec
        "$mod,W,exec,${if (host.config.user.pref.browser != "") then host.config.user.pref.browser else "luakit" }"
        "$mod,T,exec,${if (host.config.user.pref.terminal != "") then host.config.user.pref.terminal else "wezterm" }"
        "$mod SHIFT,S,exec,wallsetter"
        "$mod,S,exec,grim -g \"$(slurp)\""
        "$mod,M,exec,pcmanfm"

        # window layout
        "$mod SHIFT,Q,killactive,"
        "ALT,TAB,cyclenext,"
        "ALT,TAB,bringactivetotop,"
        "$mod,P,pseudo," # pseudo tiling
        "$mod SHIFT,I,togglesplit," # dwindle
        "$mod,F,fullscreen,"
        "$mod SHIFT,F,togglefloating,"

        # Move window
        "$mod SHIFT,left,movewindow, l"
        "$mod SHIFT,right,movewindow, r"
        "$mod SHIFT,up,movewindow, u"
        "$mod SHIFT,down,movewindow, d"
        "$mod SHIFT,code:47,centerwindow"
        "$mod SHIFT,h,movewindow, l"
        "$mod SHIFT,l,movewindow, r"
        "$mod SHIFT,k,movewindow, u"
        "$mod SHIFT,j,movewindow, d"

        # Resize window
        "$mod CONTROL,left,resizeactive, -40 0"
        "$mod CONTROL,right,resizeactive, 40 0"
        "$mod CONTROL,up,resizeactive, 0 -40"
        "$mod CONTROL,down,resizeactive, 0 40"
        "$mod CONTROL,h,resizeactive, -40 0"
        "$mod CONTROL,l,resizeactive, 40 0"
        "$mod CONTROL,k,resizeactive, 0 -40"
        "$mod CONTROL,j,resizeactive, 0 40"

        # Move focus
        "$mod,left,movefocus, l"
        "$mod,right,movefocus, r"
        "$mod,up,movefocus, u"
        "$mod,down,movefocus, d"
        "$mod,h,movefocus, l"
        "$mod,l,movefocus, r"
        "$mod,k,movefocus, u"
        "$mod,j,movefocus, d"

        # xf86 key
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute 64 toggle" # 64 sinks 65 mic
        ",XF86AudioMicMute,exec,pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

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
