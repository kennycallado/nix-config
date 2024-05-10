{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = '' '';
    # bashrcExtra = ''source ~/.config/bash/bashrc'';
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

    shellOptions = [
      "-o vi"
    ];

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

    historyIgnore = [ "yt-dpl *" "mpv *"];
    # historyIgnore = ["$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])'"];

    logoutExtra = ''
      sed -i '/.*mp4.*$/d' ~/.bash_history && sed -i '/^yt-dlp/d' ~/.bash_history && sed -i '/^mpv/d' ~/.bash_history
    '';
  };
}
