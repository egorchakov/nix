# nix config

## nix-darwin

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake github:egorchakov/nix
```

## home-manager

```bash
nix run home-manager/master -- switch --flake github:egorchakov/nix
```
