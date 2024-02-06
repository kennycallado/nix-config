# jo

## TODO

[list](./TODO.md)

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
