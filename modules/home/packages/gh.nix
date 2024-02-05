{config, ...}: {
  age.secrets.gh = {
    file = ../../../secrets/gh.age;
    path = "${config.xdg.configHome}/gh/hosts.yml";
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
