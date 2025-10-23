# nix config

## nix-darwin

```bash
# bootstrap
sudo darwin-rebuild switch --flake github:egorchakov/nix
# update
nh darwin switch github:egorchakov/nix
```

## home-manager
```bash
# bootstrap
nix run home-manager/master -- switch --flake github:egorchakov/nix
# update
nh home switch github:egorchakov/nix
```
