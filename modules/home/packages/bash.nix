{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # interactiveShellInit = (builtins.readFile ~/.config/bash/bashrc);
    initExtra = ''
      eval "$(starship init bash)"
    '';
    profileExtra = ''
      # maybe my .config/bash
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #fi
    '';
    sessionVariables = { };
    shellAliases = {
      lf = "joshuto";
      lv = "lvim";
      xc = "nix-collect-garbage && nix-collect-garbage -d";
      xcb = "sudo /run/current-system/bin/switch-to-configuration boot";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      lal = "lsd -al";
      ".." = "cd ..";
    };
  };
}
