{ host, ... }: {
  imports = [ ./${host.name} ];
}
