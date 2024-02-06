# jo

## TODO

- [X] memory: me ha parecido que al poner polykit o algo así... la memoria ha subido mucho

- [ ] waybar: waybar no está mostrando swaync
- [ ] icewm: no way to change the theme
- [ ] icewm: move configs to etc so the user can make persistent changes
- [X] icewm: pasar del menú en favor de rofi
- [ ] icewm: some things to complete
  - [ ] move windows better with icesh
  - [ ] use of Super

NOTE: continuar por línea: 772

## compile in vm

``` bash
nixos-rebuild build-vm --flake .#<name>
```

## run on the vm

``` bash
result/bin/run-<host.name>-vm -vga virtio
# -audio driver=alsa,model=hda
```

## compile and switch

``` bash
nixos-rebuild switch --flake .#<name>
```
