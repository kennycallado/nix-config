{ pkgs }:

pkgs.writeShellScriptBin "wez-ssh" ''
  yad --entry \
    --title="SSH" \
    --width=400 --center \
    --borders=10 --button="gtk-ok:0" --button="gtk-cancel:1" \
    --text="Enter the ssh connection. user@host:port" \
    --entry-text="" | xargs -I[] wezterm ssh []
''
