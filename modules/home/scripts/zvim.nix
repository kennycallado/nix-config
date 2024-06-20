{ pkgs }:

pkgs.writeShellScriptBin "zvim" "NVIM_APPNAME=nvim/lazy ${pkgs.neovim}/bin/nvim $@"
