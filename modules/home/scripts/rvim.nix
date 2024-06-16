{ pkgs }:

pkgs.writeShellScriptBin "rvim" "NVIM_APPNAME=nvim/launch ${pkgs.neovim}/bin/nvim $@"
