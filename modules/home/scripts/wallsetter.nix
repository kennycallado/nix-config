{ pkgs, config }:

pkgs.writeShellScriptBin "wallsetter" ''
  # WDIR="$XDG_PICTURES_DIR/Wallpapers"
  WDIR=${config.xdg.userDirs.pictures}/wallpapers/

  # prevent infinite recursion if there's only one file in the directory
  if [ "$(ls -1A $WDIR | wc -l)" -lt 1 ]; then exit 0; fi

  get_wallpaper() {
    local current="$1"
    local new="$(find $WDIR -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1 | sed 's:.*/::')"

    if [ -z "$current" ]; then current="$(swww query | awk '{print $8}' |  sed 's:.*/::')"; fi
    if [ "$current" == "$new" ]; then get_wallpaper $current; else echo $new; exit 0; fi
  }

  case $(shuf -i 1-5 -n 1)
  in
    1) TRANSITION="--transition-type wave --transition-angle 120 --transition-step 30" ;;
    2) TRANSITION="--transition-type wipe --transition-angle 30 --transition-step 30" ;;
    3) TRANSITION="--transition-type center --transition-step 30" ;;
    4) TRANSITION="--transition-type outer --transition-pos 0.3,0.8 --transition-step 30" ;;
    5) TRANSITION="--transition-type wipe --transition-angle 270 --transition-step 30" ;;
  esac

  swww img "$WDIR/$(get_wallpaper)" $TRANSITION
''
