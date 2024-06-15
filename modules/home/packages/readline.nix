{ ... }:

{
  programs.readline = {
    enable = true;
    extraConfig = ''
      set echo-control-characters off
      set enable-bracketed-paste on

      set editing-mode vi
      $if mode=vi
        set vi-ins-mode-string \1\e[6 q\2 I \1\e[6 q\2
        set vi-cmd-mode-string \1\e[2 q\2 N \1\e[2 q\2
        set show-mode-in-prompt on

        set keymap vi-insert
        Control-l: clear-screen
      $endif
    '';
  };
}
