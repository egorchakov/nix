# my nix config

## nix-darwin

bootstrap:
```bash
sudo darwin-rebuild switch --flake git+https://github.com/egorchakov/nix
```

subsequently:
```bash
nh darwin switch git+https://github.com/egorchakov/nix
```

## home-manager
bootstrap:
```bash
nix run home-manager/master -- switch --flake git+https://github.com/egorchakov/nix
```

subsequently:
```bash
nh home switch git+https://github.com/egorchakov/nix
```
