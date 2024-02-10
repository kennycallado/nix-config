{ host, ... }: {
  imports = [ ./${if (host.config.is_known) then host.config.name else "unknown" } ];
}
