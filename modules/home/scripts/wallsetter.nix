{ pkgs, config }:

pkgs.writeShellScriptBin "wallsetter" ''
  #
  # supports setting wallpapers for both hyprland and icewm
  WDIR=$HOME/Pictures/wallpapers/
  DESK=$XDG_SESSION_DESKTOP

  # prevent infinite recursion if there's only one file in the directory
  if [ "$(ls -1A $WDIR | wc -l)" -lt 1 ]; then exit 0; fi

  get_wallpaper() {
    local current="$1"
    local new="$(find $WDIR -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1 | sed 's:.*/::')"

    if [ -z "$current" ]; then
      
      if [ "$DESK" == "hyprland" ]; then
        current="$(swww query | awk '{print $8}' |  sed 's:.*/::')";
      else if [ "$DESK" == "icewm-session" ]; then
        current="$(cat ~/.fehbg | awk '{print $4}' | sed 's:.*/::' | sed 's/.$//g')";
      fi
      fi
    fi

    if [ "$current" == "$new" ]; then get_wallpaper $current; else echo $new; exit 0; fi
  }

  get_transition() {
    case $(shuf -i 1-5 -n 1)
    in
      1) TRANSITION="--transition-type wave --transition-angle 120 --transition-step 30" ;;
      2) TRANSITION="--transition-type wipe --transition-angle 30 --transition-step 30" ;;
      3) TRANSITION="--transition-type center --transition-step 30" ;;
      4) TRANSITION="--transition-type outer --transition-pos 0.3,0.8 --transition-step 30" ;;
      5) TRANSITION="--transition-type wipe --transition-angle 270 --transition-step 30" ;;
    esac

    echo $TRANSITION
  }

  if [ "$DESK" == "hyprland" ]; then
    swww img "$WDIR/$(get_wallpaper)" $(get_transition)
  else if [ "$DESK" == "icewm-session" ]; then
    feh --bg-fill "$WDIR/$(get_wallpaper)"
  fi
  fi
''
