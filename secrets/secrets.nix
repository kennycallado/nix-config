let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg4qvvrvP7BSMLUqPNz2+syXHF1+7qGutKBA9ndPBB+ kennycallado@hotmail.com"
  ];
in
{
  "copilot.age".publicKeys = keys;
  "docker.age".publicKeys = keys;
  "gh.age".publicKeys = keys;
}
