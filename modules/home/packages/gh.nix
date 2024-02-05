{ ... }: {
  age.secrets.gh = {
    file = ../../../secrets/gh.age;
    path = "$HOME/.config/gh/hosts.yml"; # TODO: test $HOME
  };

  home.file.".config/gh/config.yaml" = {
    text = ''
      git_protocol: https
      editor: nvim
      prompt: enabled
      pager: less -F -X
      aliases:
          co: pr checkout
      http_unix_socket:
      browser: firefox
    '';
  };
}
