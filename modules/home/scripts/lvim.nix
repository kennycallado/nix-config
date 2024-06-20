{ pkgs }:

pkgs.writeShellScriptBin "lvim" ''
  NVIM_APPNAME=lvim ${pkgs.neovim}/bin/nvim -u "/home/kenny/.local/share/lunarvim/lvim/init.lua" $@
''
