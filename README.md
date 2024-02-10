# jo

## TODO

[list](./TODO.md)

## NOTA:

rdp needs icewm, make dependents

---

live-media [link](https://hoverbear.org/blog/nix-flake-live-media/)

---

networking.networkmanager.enable = true;

And your other network configuration:

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

are two different network management systems and generally should not be used together.

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

## Some packages specifications:

### vscodeo

install from terminal latest version

``` bash
NIXPKGS_ALLOW_UNFREE=1 nix-env -f channel:nixpkgs-unstable -iA vscode
```

### monaspace

pesa unos 300Mb 🥲 

`./modules/desktop/default.nix`
``` nix
    fonts.packages = with pkgs; [
        monaspace
    ];
```

`./modules/home/files/wezterm/wezterm.lua`
``` lua
config.font = wezterm.font({
  family = 'Monaspace Neon',
  -- family='Monaspace Argon',
  -- family='Monaspace Xenon',
  -- family='Monaspace Radon',
  -- family='Monaspace Krypton',
  weight = 'Regular',
  harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
})
```

More options in [link](https://gist.github.com/ErebusBat/9744f25f3735c1e0491f6ef7f3a9ddc3).

## INSTALLATION

### pre

**Dependencies**:
- git
- neovim
- bitwarden-cli

``` bash
bw list items --search <id> | jq '.[].notes' | xargs -I][ echo -e ][ > id_ed25519
```

``` bash
mkdir ~/dev && git clone git@github.com:kennycallado/nix-config.git ~/dev/nix-config
```

### install

``` bash
cd ~/dev/nix-config/ &&
nixos-rebuild switch --flake .#<name>
```

### post

**clean up**:
- reboot
- xc
- xcb

