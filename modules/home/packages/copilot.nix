{ ... }: {
  age.secrets.copilot = {
    file = ../../../secrets/copilot.age;
    path = "$HOME/.config/github-copilot/hosts.json"; # TODO: test $HOME
  };
}
