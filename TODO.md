
## TODO

- [ ] ble.sh: need config
  - [link](https://starship.rs/advanced-config/)

- [X] luakit: `WEBKIT_DISABLE_COMPOSITING_MODE=1 luakit`
  - works better with it

- [X] alacritty: migrate to toml

- [~] migration to 24.05

- [X] lvim: copilot with `"zbirenbaum/copilot.lua"`
  - [link](https://github.com/zbirenbaum/copilot.lua)
- [~] zoxide: directory jump
  - alias z="zoxide"
  - alias cd="z cd"

- [ ] miniserve: rust http static server
  - is there any other alternative?
- [?] chezmoi: because of android

- [X] hyperland: Is enabled twice?
- [X] lunarvim: issue with rest.nvim specify version for now
  ``` lua
  {
  ...
    "rest-nvim/rest.nvim",
    version = "v1.0.0",
    dependencies = { "nvim-lua/plenary.nvim" },
  ...
  }
  ```
- [ ] wl-screenrec: nix-shell -p wl-screenrec && wl-screenrec --audio
  - There was a script with it to select screen region, but don't know where

- [ ] firefox: extension for pwa
  - [link](https://search.nixos.org/packages?channel=unstable&show=firefoxpwa)
- [ ] firefox: [link](https://code.balsoft.ru/balsoft/nixos-config/src/branch/master/profiles/applications/firefox.nix)
  - take a look of the rest
   
- [X] memory: me ha parecido que al poner polykit o algo así... la memoria ha subido mucho

- [X] develpment: option for **unstable** vscode, at least until stable >1.84
- [X] waybar: waybar no está mostrando swaync
- [ ] waybar: better styles

- [ ] icewm: restrictive config possible new users
- [ ] icewm: move configs to etc so the user can make persistent changes

- [X] icewm: no way to change the theme
- [X] icewm: pasar del menú en favor de rofi
- [X] icewm: some things to complete
  - [X] move windows better with icesh
  - [X] use of Super
