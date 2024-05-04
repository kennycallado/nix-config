{ pkgs, host, ... }:

{
  home.packages = with pkgs; [
    picom
  ];

  home.file.".icewm/themes" = {
    source = ../files/icewm/themes;
    recursive = true;
  };

  home.file.".icewm/startup" = {
    source = ../files/icewm/startup;
  };

  home.file.".icewm/preferences" = {
    source = ../files/icewm/preferences;
  };

  home.file.".icewm/toolbar" = {
    source = ../files/icewm/toolbar;
  };

  home.file.".icewm/keys" = {
    text =
      let
        mod = if (host.config.is_vm) then "AltGr" else "Super";
      in
      ''
        # launcher
        key "${mod}+ " rofi -show drun
        key "${mod}+Shift+ " rofi -show power-menu -modi power-menu:rofi-power-menu

        # exec
        key "${mod}+t" ${if (host.config.user.pref.terminal != "") then host.config.user.pref.terminal else "wezterm" }
        key "${mod}+w" ${if (host.config.user.pref.browser != "") then host.config.user.pref.browser else "luakit" }
        key "${mod}+m" pcmanfm

        # move window
        key "${mod}+Shift+k" sh -c "icesh -f top"
        key "${mod}+Shift+j" sh -c "icesh -f bottom"
        key "${mod}+Shift+h" sh -c "icesh -f left"
        key "${mod}+Shift+l" sh -c "icesh -f right"
        key "${mod}+Shift+ñ" sh -c "icesh -f center"

        # resize window
        key "${mod}+Ctrl+k" sh -c "icesh -f getGeometry | sed -rn 's/[^[:digit:]]*([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]*/echo $((\1+0))x$((\2-20))+/p' | xargs -I[] sh -c [] | xargs -I[] icesh -f setGeometry []"
        key "${mod}+Ctrl+j" sh -c "icesh -f getGeometry | sed -rn 's/[^[:digit:]]*([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]*/echo $((\1+0))x$((\2+20))+/p' | xargs -I[] sh -c [] | xargs -I[] icesh -f setGeometry []"
        key "${mod}+Ctrl+h" sh -c "icesh -f getGeometry | sed -rn 's/[^[:digit:]]*([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]*/echo $((\1-20))x$((\2+0))+/p' | xargs -I[] sh -c [] | xargs -I[] icesh -f setGeometry []"
        key "${mod}+Ctrl+l" sh -c "icesh -f getGeometry | sed -rn 's/[^[:digit:]]*([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]*/echo $((\1+20))x$((\2+0))+/p' | xargs -I[] sh -c [] | xargs -I[] icesh -f setGeometry []"
        key "${mod}+Ctrl+s" sh -c "icesh -f sizeto 98% 98% ; icesh -f center ; icesh -f top"
      '';
  };
}
